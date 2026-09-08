# auto-experto

Skill de [Claude Code](https://claude.com/claude-code) que convierte a Claude en
un experto en automóviles con **base de conocimiento propia, estructurada y con
procedencia**: qué comprar, qué evitar, qué se rompe y cuánto cuesta arreglarlo.

No es un chatbot que opina de coches. Es un repositorio de hechos verificables
que crece cada vez que se ingiere una fuente nueva.

## La idea

La fiabilidad de un coche **no es una propiedad del modelo, es de su motor**.
Un BMW 328i puede ser una compra excelente o una ruina de 6.000 USD según el
año: el E90 lleva un seis en línea atmosférico indestructible y el F30 lleva un
cuatro cilindros turbo que rompe las guías de la cadena de distribución. Mismo
nombre comercial, riesgo opuesto.

Por eso la base se organiza **por motor primero** y por modelo después. Un fallo
se documenta una vez, en la ficha del motor, y lo heredan todos los modelos que
lo montan.

## Los cuatro ejes

Toda consulta se sitúa en cuatro ejes antes de responder:

| Eje | Valores |
|---|---|
| **Vehículo** | marca + generación + año + motor |
| **Intención** | comprar · reparar · mantener · vender |
| **Rol** | comprador · propietario · mecánico |
| **Mercado** | nuevo · usado · importado |

El que más cambia la respuesta es el **rol**. Al comprador se le da una decisión
y una lista de revisión; al propietario, síntoma → causa → coste → urgencia; al
mecánico, códigos y valores sin didáctica. Los guiones están en `references/`.

## Estructura

```
SKILL.md                      router: detecta los cuatro ejes y elige qué leer
knowledge/
  INDEX.md                    tabla marca → generación → año → motor
  motores/<marca>-<código>.md  ← el 80 % de la verdad vive aquí
  <marca>/<gen>-<modelo>.md    lo que no depende del motor
references/
  rol-comprador.md            guiones de respuesta por rol
  rol-propietario.md
  rol-mecanico.md
  contexto-colombia.md        traducción de precios y disponibilidad al mercado local
  niveles-confianza.md        ✅ / 🟡 / 🔵 / ⚠️
  como-ingerir.md             procedimiento para añadir una fuente
fuentes/registro.md           qué fuente alimentó qué, y cuánto pesa
scripts/ingest-youtube.sh     extracción de transcripciones (fuera del repo)
```

## Procedencia y confianza

Cada dato lleva marcador. Un canal de YouTube no es una fuente técnica: repite
lo que repiten otros canales y redondea precios. Sirve para orientar una compra,
**nunca** para justificar una reparación cara.

| | Significado |
|---|---|
| ✅ | Dos o más fuentes independientes, o dato de fábrica |
| 🟡 | Una sola fuente |
| 🔵 | Conocimiento general, pendiente de verificar |
| ⚠️ | Fuentes en conflicto — se guardan las dos versiones |

Cuando dos fuentes se contradicen, **no se resuelve a la fuerza**: se registran
ambas. Un repo que esconde sus contradicciones miente.

## Qué NO hay aquí

**Transcripciones de vídeos ajenos.** El repo guarda hechos destilados y la
referencia a la fuente, no copias de su contenido. Los hechos (que el N20 rompe
guías de cadena) no son de nadie; la transcripción palabra por palabra sí.
Además viene sucia: en la primera fuente, "F32 440i" salió como "F3240i".

Las transcripciones de trabajo se generan fuera del repo y están en `.gitignore`.

## Estado

Cuatro fuentes ingeridas. La base **sigue muy sesgada a BMW**: es la única marca
con fichas de motor y datos de coste. Lo demás son notas de una sola fuente, y
está dicho así en cada archivo.

- **10 motores** BMW (M54, N52, N54, N55, N20, N63, B48, B58, S65, S85)
- **15 modelos** BMW, en verde y en rojo
- Gama actual y decodificador de la nomenclatura (eje *coche nuevo*)
- Principios transversales de compra en usado
- Notas sueltas de VW, Toyota, Jeep y Ford

### Lo que ya sabe hacer que no es obvio

- **Sostener una contradicción sin resolverla.** Una fuente recomienda comprar
  BMW usados baratos y otra dice que ningún alemán viejo compensa como coche
  diario, en el mismo rango de precio. Las dos son defendibles: depende de si es
  el único coche del comprador. La skill pregunta eso antes de recomendar.
- **Distinguir fuentes independientes de fuentes que solo se repiten.** Dos
  vídeos del mismo canal no confirman nada entre sí, y está anotado.
- **Rechazar lo que una fuente afirma mal.** Hay dos casos registrados en los
  que la conclusión es defendible pero la explicación causal es inventada; se
  guardan marcados como falsos para que no se repitan.

### Pendiente

- Fichas S55, S58, S63, S68
- Datos duros de las marcas no alemanas
- Precios reales del mercado colombiano — `contexto-colombia.md` es un esqueleto

## Instalación

```bash
git clone https://github.com/elisaul77/auto-experto.git
ln -s "$PWD/auto-experto" ~/.claude/skills/auto-experto
```

La skill se activa sola en consultas sobre coches.

## Ingesta: nota sobre YouTube

`scripts/ingest-youtube.sh <url>` baja los subtítulos originales (`es-orig`, el
reconocimiento del audio real, no la traducción automática), los limpia —vienen
en cascada, cada bloque repite el anterior— y deja la transcripción fuera del
repo. Si no hay subtítulos, cae al STT local.

Necesita dos cosas que no son obvias: **cookies del navegador**
(`--cookies-from-browser firefox`, si no YouTube responde *"Sign in to confirm
you're not a bot"*) y un **runtime JavaScript** (Deno, para el reto cifrado; sin
él responde *"The page needs to be reloaded"*). El script se los descarga solos.

Aun así, YouTube endurece esto cada pocas semanas y hay días en que ninguna
combinación pasa. Cuando ocurre, la vía que queda es un navegador real con
sesión iniciada.

## Licencia

MIT
