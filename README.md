# Conversor de Documentos a Markdown

Este repositorio incluye dos implementaciones distintas para convertir documentos y archivos PDF a formato Markdown. Ambas herramientas están diseñadas para ejecutarse en Windows 11 sin necesidad de instalaciones complejas por parte del usuario final, soportando flujos rápidos y desatendidos.

## Estructura del Repositorio

- **`/pdf-tools/`**: Implementación basada en la API de **Stirling PDF**. Convierte archivos PDF conectándose a una instancia local (o remota) de Stirling PDF de forma transparente.
- **`/mark-it-down/`**: Implementación basada en Python y la librería **MarkItDown** de Microsoft. Soporta múltiples formatos (PDF, DOCX, XLSX, etc.) y puede ser empaquetada como un único archivo `.exe` para que los usuarios no necesiten tener Python instalado.

---

## 1. Versión API (Stirling PDF)
Ubicada en la carpeta `pdf-tools/`, utiliza PowerShell para enviar el documento a la API de Stirling PDF (`http://localhost:8080/api/v1/convert/pdf/markdown`) y guardar la respuesta.

### Cómo usar:
1. **Drag & Drop (Arrastrar y Soltar)**:
   Arrastra tu archivo PDF directamente sobre el archivo `convert.bat`. El script se ejecutará de forma rápida y el archivo `.md` resultante se guardará en la misma carpeta que el PDF original.
   
2. **Línea de Comandos (CLI)**:
   Puedes invocar el script pasando argumentos:
   ```cmd
   convert.bat "C:\ruta\al\archivo.pdf"
   ```
   También puedes especificar una ruta de salida diferente:
   ```cmd
   convert.bat "C:\ruta\al\archivo.pdf" -o "C:\salida\documento.md"
   ```

3. **Doble Clic (Modo Interactivo)**:
   Si haces doble clic en `convert.bat` o `convert.ps1` sin arrastrar nada, se abrirá la consola preguntándote la ruta del archivo de entrada y, de forma opcional, la ruta donde quieres guardarlo.

*Nota: Puedes definir una clave de API global en tu entorno si Stirling PDF requiere autenticación, usando la variable de entorno `SECURITY_CUSTOMGLOBALAPIKEY`.*

---

## 2. Versión Local (Python + MarkItDown)
Ubicada en la carpeta `mark-it-down/`, es la versión más completa ya que no depende de contenedores de Stirling PDF y soporta una gran variedad de archivos de entrada utilizando la librería `markitdown`.

### Generar el ejecutable (Sin instalación para los usuarios)
Para evitar que los usuarios finales tengan que instalar Python, puedes generar un `.exe` autocontenido. 

1. Abre una terminal y navega hasta la carpeta `mark-it-down/`.
2. Crea el entorno y descarga las dependencias ejecutando:
   ```cmd
   python -m venv venv
   venv\Scripts\activate
   pip install -r requirements.txt
   ```
3. Ejecuta PyInstaller para crear el archivo `.exe`:
   ```cmd
   pyinstaller --onefile convert.py
   ```
4. Encontrarás el `convert.exe` en la subcarpeta `dist/`. Mueve este `.exe` a la carpeta `mark-it-down/`.

Una vez tengas el `convert.exe`, el uso es idéntico a la versión de API. Puedes arrastrar y soltar archivos directamente en el ejecutable, o usarlo vía CLI:
```cmd
convert.exe "C:\ruta\al\documento.docx" -o "C:\salida.md"
```

Si el ejecutable no se genera, los usuarios pueden usar directamente el archivo `convert.bat` (que automatiza la creación del entorno virtual y la instalación de los componentes de Python la primera vez que se usa).

### Formatos soportados por MarkItDown
- PDF, Word (docx), PowerPoint (pptx), Excel (xlsx/xls)
- Archivos de texto (CSV, JSON, XML)
- HTML
- Epubs y muchos más.

---

## Nombres Automáticos Seguros
Si ejecutas cualquier de las dos herramientas y no proporcionas un nombre de salida (`-o`), el archivo `.md` se generará en el mismo directorio del archivo original, y con su mismo nombre base. Si dicho archivo `.md` ya existiese en el destino, las herramientas añadirán automáticamente un número al final (ej. `archivo (1).md`) para prevenir la sobrescritura y pérdida de datos accidental.
