# Conversor de Archivos a Markdown con MarkItDown

Este proyecto permite convertir archivos locales como PDFs, documentos de Word (DOCX) y Excel (XLSX) a formato Markdown (`.md`) utilizando la biblioteca [`markitdown` de Microsoft](https://github.com/microsoft/markitdown).

Existen dos formas principales de utilizar esta herramienta: un modo automatizado utilizando "Arrastrar y Soltar", y un modo directo a través del script de Python para usuarios más técnicos.

---

## Opción 1: Arrastrar y Soltar (Drag & Drop - Recomendado)

Esta es la forma más rápida y sencilla de convertir archivos, diseñada para una experiencia "Zero-Touch" donde no es necesario abrir la consola de comandos.

1. Ubica el archivo que deseas convertir (PDF, DOCX, XLSX).
2. **Arrastra el archivo y suéltalo** encima del archivo `convert.bat`.
3. El sistema se encargará del resto de forma automática:
   - **La primera vez que lo uses:** El script detectará que no tienes un entorno configurado, creará una carpeta oculta `venv` e instalará automáticamente `markitdown` y sus dependencias. Esto puede tomar algunos segundos.
   - **Las siguientes veces:** El script utilizará el entorno ya configurado y realizará la conversión al instante.
4. Una vez procesado, la ventana de la terminal se cerrará automáticamente y aparecerá un nuevo archivo con el mismo nombre y extensión `.md` exactamente en la misma carpeta donde estaba el archivo original.

---

## Opción 2: Uso Directo con Python (Avanzado)

Si prefieres realizar el proceso manualmente, automatizarlo desde otro lado o integrar el conversor en tus propios scripts, puedes interactuar directamente con `convert.py`.

### 1. Configurar el Entorno
Antes de ejecutar el script manualmente, necesitas crear un entorno virtual e instalar las dependencias:

```bash
# Abre la terminal en la carpeta de este repositorio (S:\documents\GitHub\mark-it-down\)

# 1. Crear el entorno virtual
python -m venv venv

# 2. Activar el entorno virtual en Windows
.\venv\Scripts\activate

# 3. Instalar la librería requerida
pip install "markitdown[all]"
```

### 2. Ejecutar la Conversión
Con el entorno configurado y activado, puedes ejecutar el script enviándole la ruta absoluta del archivo destino como parámetro. 

Efectivamente, si llamas al script desde cualquier otra ubicación, la ruta absoluta sería: `"S:\documents\GitHub\mark-it-down\convert.py"`.

**Ejemplo de uso:**

```bash
python "S:\documents\GitHub\mark-it-down\convert.py" "C:\Users\juanp\Documents\reporte_financiero.xlsx"
```

El script tomará el archivo original y guardará el Markdown resultante (`reporte_financiero.md`) en la misma ruta de origen (`C:\Users\juanp\Documents\`).

---

**Nota:** Es indispensable tener Python instalado en el sistema y agregado al `PATH` (variables de entorno) de Windows para que ambas modalidades funcionen.
