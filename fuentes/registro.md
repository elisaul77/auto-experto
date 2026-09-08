# Registro de fuentes

Cada ficha cita por identificador. Aquí está qué es cada uno y qué fiabilidad
tiene. **Las transcripciones no se guardan en el repo** — ver
[como-ingerir](../references/como-ingerir.md).

## Fiabilidad por tipo de fuente

| Tipo | Peso | Nota |
|---|---|---|
| Manual de taller / TIS / boletín oficial | Alto | Dato de fábrica |
| Foro especializado con consenso largo | Medio-alto | Bimmerforums, r/BMW |
| Canal de YouTube técnico | Medio | Si desarma y mide |
| Canal de YouTube de listas | **Bajo** | Refrito de otros canales; sirve para orientar, no para decidir una reparación |
| Vendedor / concesionario | Muy bajo | Interés directo |

---

## [V1] — GARAJE SUV NERD

- **Título:** "10 MEJORES Modelos BMW para Comprar en 2026 | Confiables y Baratos"
- **URL:** https://www.youtube.com/watch?v=5BHQcmnPXg0
- **Publicado:** 2026-08-22 · **Duración:** 18:36
- **Ingerido:** 2026-09-07
- **Tipo:** canal de listas → peso **bajo**, todo lo suyo entra como 🟡
- **Extraído:** 10 modelos con rango de precio (mercado EE. UU.), mapa de
  motores buenos (N52, M54, N55, B48, B58) contra malos (N20, N54, N63),
  y la tesis de que la fiabilidad BMW se decide por motor, no por modelo.
- **Sesgo detectado:** precios exclusivamente de EE. UU.; no menciona coste de
  mantenimiento periódico, solo precio de compra. Optimista con los seis en
  línea sin cuantificar el gasto anual.
- **Errores de la transcripción automática** (corregidos al fichar): "F3240i"
  = F32 440i; "F3040i" = F30 340i; "E90 328i yi 2007-211" = 2007-2011.

## [V2] — CarsLatino *(pendiente)*

- **Título:** "5 BMW QUE NO DEBERÍAS COMPRAR Y 5 QUE SI"
- **URL:** https://www.youtube.com/watch?v=hfnxIwleCjo
- **Publicado:** 2023-04-04 · **Duración:** 12:06
- **Estado:** ⏳ **sin ingerir** — YouTube bloqueó la extracción el 2026-09-08
  (ver README, sección Ingesta). Sin subtítulos accesibles y sin formatos de
  audio desde los clientes alternativos del extractor.
- **Interés especial:** es la primera fuente que puede **contradecir** a [V1].
  Un "no deberías comprar" contra una lista de recomendados es justo el caso
  para el que existe el marcador ⚠️.

## [V3] — gama BMW actual (nomenclatura)

- **URL:** https://www.youtube.com/watch?v=IKsBfiqv7fY · **Duración:** ~6:10
- **Ingerido:** 2026-09-08
- **Tipo:** guía de gama → peso **bajo-medio**. No es fuente técnica, pero la
  estructura de la gama es dato objetivo y comprobable contra el catálogo.
- **Pista de subtítulos:** inglés con errores de reconocimiento. **No había
  pista `es-orig`.** Todo dato numérico se contrastó antes de fichar.
- **Extraído:** decodificador de la nomenclatura (impar = gama principal, par =
  derivado coupé del impar inferior, `M` delante = M Performance vs `M` solo =
  modelo M), el mapa tracción delantera/trasera por modelo, la gama completa
  del 1 al 8 y el descatalogado del Serie 6 GT en 2023.
- **Aporta un eje nuevo:** primera fuente sobre **coche nuevo**. [V1] era usado.

### Errores detectados en la transcripción (corregidos al fichar)

| En la transcripción | Real |
|---|---|
| "330 injection" | 330i |
| "M135 and XDrive" / "M235 EX Drive" | M135 xDrive / M235 xDrive |
| "M5 Turing" | M5 Touring |
| "Together they produce 72 horsepower" | ~727 CV (cifra truncada) |
| "453 CV y 5 CV en su versión CS" | cifra de la CS perdida |
| "4 cil. turbo de 258 CV **en el 440i**" | es el **430i**; el 440i es el seis |
| Serie 4: "tres puertas" | dos puertas |

**Lección de método:** una pista de subtítulos traducida o mal reconocida
corrompe justo lo que más importa —cifras y nombres de modelo— dejando el texto
con aspecto perfectamente legible. Por eso el script ahora avisa cuando la pista
no es `es-orig` y ninguna cifra de una fuente así entra sin contrastar.

### Sin contradicciones con [V1]

[V1] habla de usado y generaciones F/E; [V3] de nuevo y generaciones G. No se
solapan. La primera contradicción real sigue pendiente con [V2].

## [V4] — directo de preguntas y respuestas (canal de habla hispana, ~may-2024)

- **URL:** https://www.youtube.com/watch?v=wH075CX_ug4 · **Duración:** ~8 min
- **Ingerido:** 2026-09-08
- **Tipo:** opinión en directo → peso **bajo** en datos, **alto en criterio**.
  No aporta cifras verificables; aporta heurísticas de compra.
- **Pista:** inglés traducido automáticamente. **Muy corrupta** (ver abajo).
- **Moneda:** "pesos". Por el sorteo y el registro parece canal mexicano, pero
  **sin verificar** 🔵. Importa: 150.000 MXN y 150.000 COP no son comparables.
- **Aporta:** primera fuente **no centrada en BMW** y primera con principios
  transversales de compra en usado → `references/principios-compra-usado.md`.
- **Confirma** ✅ que el estado del ejemplar puede pesar más que la estadística
  del modelo. Segundo apoyo independiente frente a [V1]: sube de 🟡 a ✅.

### ⚠️ Contradice a [V1]

[V1] recomienda BMW usados baratos; [V4] sostiene que ningún alemán viejo
compensa como coche diario, en el mismo rango de precio. Registrada sin
resolver en `references/principios-compra-usado.md`: depende de la situación
del comprador, dato que ninguna de las dos fuentes considera.

### Errores de reconocimiento (reconstruidos, marcados 🔵 en las fichas)

| En la transcripción | Reconstrucción |
|---|---|
| "JTM K616 2.5" | Jetta MK6 2.5 |
| "GMI engine" / "Pentas" | Hemi / Pentastar |
| "Rap 4x4", "B6 3.5" | RAV4 4x4, V6 3.5 |
| "Power Boot" | PowerBoost |
| "motor de 2 cilindros" (×2) | 4 cilindros |
| "swing time" / "switch spot" | sweet spot |
| "Polo GLI" | ambiguo: Jetta GLI o Polo GTI — **no fichado** |

La densidad de errores aquí es mayor que en [V3]: es audio de directo,
coloquial y con música. **Ninguna cifra de esta fuente se fichó como dato.**
