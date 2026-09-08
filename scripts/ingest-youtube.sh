#!/usr/bin/env bash
# Extrae la transcripción de un vídeo de YouTube para destilarla a fichas.
#
# La transcripción NO va al repo: se deja fuera a propósito.
# Ver references/como-ingerir.md
#
#   ingest-youtube.sh <url> [dir-salida]
set -euo pipefail

URL="${1:?uso: ingest-youtube.sh <url> [dir-salida]}"
OUT="${2:-$HOME/Documentos}"
BIN="$HOME/.cache/auto-experto/bin"
STT="http://localhost:8602/v1/audio/transcriptions"
mkdir -p "$BIN" "$OUT"

# --- herramientas -----------------------------------------------------------
# En este equipo no hay yt-dlp instalado y los contenedores no alcanzan PyPI,
# así que se usan binarios sueltos cacheados.
if [ ! -x "$BIN/yt-dlp" ]; then
  echo "· bajando yt-dlp..."
  curl -sSL -o "$BIN/yt-dlp" \
    https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/latest/download/yt-dlp_linux
  chmod +x "$BIN/yt-dlp"
fi
# YouTube cifra las URLs con un reto en JavaScript: sin runtime JS el
# extractor responde "The page needs to be reloaded".
if [ ! -x "$BIN/deno" ]; then
  echo "· bajando deno (runtime JS para el reto de YouTube)..."
  curl -sSL -o "$BIN/deno.zip" \
    https://github.com/denoland/deno/releases/latest/download/deno-x86_64-unknown-linux-gnu.zip
  (cd "$BIN" && unzip -oq deno.zip && rm -f deno.zip && chmod +x deno)
fi
export PATH="$BIN:$PATH"

YD=("$BIN/yt-dlp" --js-runtimes deno --cookies-from-browser firefox --no-warnings)
# El id se saca de la URL: pedirlo a yt-dlp gasta una llamada y falla si
# el extractor está bloqueado, dejando todo con nombre "video".
ID=$(printf %s "$URL" | grep -oE '[?&]v=[A-Za-z0-9_-]{11}' | cut -c4- || true)
[ -n "$ID" ] || ID=$(printf %s "$URL" | grep -oE '[A-Za-z0-9_-]{11}$' || echo video)

# --- 1) intento rápido: subtítulos ------------------------------------------
# Preferir SIEMPRE es-orig: es el reconocimiento del audio original.
# 'es' y 'en' son traducciones automáticas (y 'en' es traducción de traducción).
echo "· buscando subtítulos..."
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
if "${YD[@]}" --write-auto-sub --write-sub --sub-langs "es.*,en.*" \
     --skip-download -o "$TMP/v.%(ext)s" "$URL" >/dev/null 2>&1; then
  VTT=$(ls "$TMP"/v.es-orig.vtt "$TMP"/v.es.vtt "$TMP"/v.en.vtt 2>/dev/null | head -1 || true)
  PISTA=$(basename "${VTT:-none}" .vtt | sed 's/^v\.//')
  case "$PISTA" in
    es-orig) echo "· pista es-orig (audio original) — calidad buena" ;;
    none)    : ;;
    *) echo "· ATENCIÓN: pista '$PISTA' es TRADUCCIÓN AUTOMÁTICA."
       echo "  Los datos numéricos y los nombres de modelo llegan corrompidos."
       echo "  Verificar toda cifra antes de fichar." ;;
  esac
fi

# --- 2) plan B: audio + STT local -------------------------------------------
if [ -z "${VTT:-}" ]; then
  echo "· sin subtítulos accesibles; audio -> STT local"
  # Los clientes ligeros (mweb/ios) pasan el control anti-bot pero suelen venir
  # sin formatos de audio. Si esto falla, no hay vía sin navegador real.
  "${YD[@]}" -f bestaudio -x --audio-format wav -o "$TMP/a.%(ext)s" "$URL" \
    || { echo "ERROR: YouTube bloqueó la extracción. Ver README > Ingesta." >&2; exit 1; }
  curl -sS -X POST "$STT" -F "file=@$TMP/a.wav" -F "language=es" \
    -F "response_format=json" | python3 -c 'import sys,json;print(json.load(sys.stdin)["text"])' \
    > "$OUT/$ID.transcripcion.txt"
  echo "listo: $OUT/$ID.transcripcion.txt"; exit 0
fi

# --- 3) limpiar el VTT ------------------------------------------------------
# Los subtítulos automáticos vienen EN CASCADA: cada bloque repite el anterior
# y añade una palabra (efecto karaoke). Sin deduplicar, el texto es ilegible.
python3 - "$VTT" "$OUT/$ID.transcripcion.md" "$URL" "${PISTA:-?}" <<'PY'
import re, sys, html
src, dst, url, pista = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
blocks, t = [], None
for line in open(src, encoding='utf-8'):
    line = line.rstrip('\n')
    m = re.match(r'^(\d\d:\d\d:\d\d)\.\d+ --> ', line)
    if m: t = m.group(1); continue
    if not line.strip() or line.startswith(('WEBVTT','Kind:','Language:','NOTE')): continue
    txt = html.unescape(re.sub(r'<[^>]+>', '', line)).strip()
    if txt and t: blocks.append((t, txt))

seen = []
for t, txt in blocks:
    if seen and (txt == seen[-1][1] or seen[-1][1].endswith(txt)): continue
    seen.append((t, txt))

out, prev = [], ''
for t, txt in seen:
    if prev and txt.startswith(prev): txt = txt[len(prev):].strip()
    if txt: out.append((t, txt))
    prev = txt

secs = lambda s: int(s[:2])*3600 + int(s[3:5])*60 + int(s[6:8])
paras, cur, start = [], [], secs(out[0][0])
for t, txt in out:
    if secs(t) - start >= 30 and cur:
        paras.append((start, ' '.join(cur))); cur, start = [], secs(t)
    cur.append(txt)
if cur: paras.append((start, ' '.join(cur)))

with open(dst, 'w', encoding='utf-8') as f:
    f.write(f'# Transcripción de trabajo\n\n{url}\n\nPista de subtítulos: **{pista}**\n\n')
    f.write('> Material de trabajo, NO se versiona en el repo.\n\n')
    for s, p in paras:
        f.write(f'**[{s//60:02d}:{s%60:02d}]** {p}\n\n')
print(f'{len(paras)} párrafos, {sum(len(p.split()) for _, p in paras)} palabras')
PY
echo "listo: $OUT/$ID.transcripcion.md"
