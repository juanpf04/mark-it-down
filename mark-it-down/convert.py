import sys
import os
import time
import argparse
from markitdown import MarkItDown

def get_unique_filename(output_path):
    if not os.path.exists(output_path):
        return output_path
    
    base, ext = os.path.splitext(output_path)
    if not ext:
        ext = ".md"
        
    counter = 1
    while True:
        new_path = f"{base} ({counter}){ext}"
        if not os.path.exists(new_path):
            return new_path
        counter += 1

def main():
    interactive = False
    
    # Check if run without arguments (Double Click mode)
    if len(sys.argv) == 1:
        interactive = True
        print("=== MarkItDown Local Converter ===")
        input_file = input("Introduce o arrastra la ruta del archivo a convertir:\n> ").strip()
        # Clean quotes if dragged into the terminal
        input_file = input_file.strip('"').strip("'")
        
        output_file = input("\nIntroduce la ruta de salida (o presiona Enter para usar el mismo directorio):\n> ").strip()
        output_file = output_file.strip('"').strip("'")
        
        if not input_file:
            print("No se proporcionó ningún archivo.")
            os.system("pause")
            sys.exit(1)
            
    else:
        # CLI / Drag & Drop mode
        parser = argparse.ArgumentParser(description="Convert files to Markdown using MarkItDown.")
        parser.add_argument("input", help="Path to the input file")
        parser.add_argument("-o", "--output", help="Path to the output file (optional)")
        
        args = parser.parse_args()
        input_file = args.input
        output_file = args.output

    if not os.path.isfile(input_file):
        print(f"\nError: No se encontró el archivo '{input_file}'.")
        if interactive:
            os.system("pause")
        else:
            time.sleep(3)
        sys.exit(1)

    # Determine output path
    if not output_file:
        base_name = os.path.splitext(os.path.basename(input_file))[0]
        directory = os.path.dirname(os.path.abspath(input_file))
        output_file = os.path.join(directory, f"{base_name}.md")
    elif not output_file.lower().endswith('.md'):
        output_file += ".md"

    # Ensure output filename is absolute if it's not
    output_file = os.path.abspath(output_file)

    # Ensure uniqueness
    output_file = get_unique_filename(output_file)

    print(f"\nConvirtiendo '{input_file}' a Markdown...")
    try:
        md = MarkItDown()
        result = md.convert(input_file)
        
        # Ensure output directory exists if specified
        output_dir = os.path.dirname(output_file)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir)
            
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(result.text_content)
        print(f"\n¡Éxito! Archivo guardado en '{output_file}'")
        
    except Exception as e:
        print(f"\nError durante la conversión: {e}")
        if interactive:
            os.system("pause")
        else:
            time.sleep(3)
        sys.exit(1)

    # Success pause behavior
    if interactive:
        print("")
        os.system("pause")
    else:
        # Give user time to read the success message in D&D / CLI mode
        time.sleep(3)

if __name__ == "__main__":
    main()
