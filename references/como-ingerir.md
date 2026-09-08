# Cómo ingerir una fuente nueva

## Regla número uno: destilar, no archivar

**Nunca se guarda en el repo la transcripción literal de un vídeo ajeno.**
Dos razones, las dos serias:

1. **Legal.** El repo es público. Una transcripción palabra por palabra es una
   copia del contenido de otra persona. Los **hechos** que contiene (que el N20
   rompe guías de cadena, que el X5 40i cuesta 32-44k USD) no son de nadie y se
   pueden almacenar y citar sin problema.
2. **Calidad.** Las transcripciones automáticas vienen sucias: en la primera
   fuente ingerida, "F32 440i" salió como "F3240i" y un precio como
   "22,000 days". Guardar ruido es peor que no guardar nada.

Lo que se guarda es la **ficha estructurada** + la **referencia a la fuente**.
La transcripción de trabajo vive fuera del repo y se descarta.

## Procedimiento

1. **Extraer.** `scripts/ingest-youtube.sh <url> [dir-salida]`. Deja la
   transcripción **fuera del repo** (por defecto en `~/Documentos`).
2. **Leer y separar** en tres cubos:
   - hechos técnicos (motor, fallo, kilometraje, coste)
   - precios (siempre con mercado y fecha)
   - opinión del autor (va como cita atribuida o no va)
3. **Motor primero.** Crear o actualizar `knowledge/motores/`. Si el fallo es
   del motor, va ahí aunque la fuente hable de un modelo concreto: así lo
   heredan todos los modelos que lo montan.
4. **Modelo después.** Solo lo que no depende del motor.
5. **Marcar confianza** en cada dato nuevo — ver
   [niveles-confianza](niveles-confianza.md). Una fuente nueva y sola es 🟡.
   Si confirma algo que ya estaba en 🟡, sube a ✅ y se citan las dos.
6. **Conflictos:** no borrar el dato viejo. Añadir el nuevo con ⚠️ y explicar
   cuál parece más fiable y por qué.
7. **Registrar** la fuente en `fuentes/registro.md` con su identificador `[Vn]`.
8. **Actualizar** `knowledge/INDEX.md`.

## Qué NO ingerir

- Opiniones de estilo sin dato ("es un coche con carácter").
- Precios sin mercado identificable.
- Cifras de potencia o consumo del folleto: eso está en cualquier ficha técnica
  y no aporta. El valor de este repo es **lo que se rompe y lo que cuesta**.
