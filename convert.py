import sys
import os
from markitdown import MarkItDown

def main():
    if len(sys.argv) < 2:
        print("Uso: python convert.py <ruta_del_archivo>")
        sys.exit(1)

    input_file = sys.argv[1]
    
    if not os.path.isfile(input_file):
        print(f"Error: No se encontró el archivo '{input_file}'.")
        sys.exit(1)

    # Obtener el directorio y el nombre base del archivo
    base_name = os.path.splitext(os.path.basename(input_file))[0]
    directory = os.path.dirname(input_file)
    output_file = os.path.join(directory, f"{base_name}.md")

    print(f"Convirtiendo '{input_file}' a Markdown...")
    try:
        md = MarkItDown()
        result = md.convert(input_file)
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(result.text_content)
        print(f"¡Éxito! Archivo guardado en '{output_file}'")
    except Exception as e:
        print(f"Error durante la conversión: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
