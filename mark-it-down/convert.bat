@echo off
setlocal

:: Wrapper para Drag & Drop / CLI hacia el script de Python

:: Obtener el directorio donde se encuentra este archivo .bat
set "BAT_DIR=%~dp0"

:: Verificar si existe el ejecutable generado por pyinstaller
if exist "%BAT_DIR%convert.exe" (
    "%BAT_DIR%convert.exe" %*
    exit /b
)

:: Si no existe el exe, usar Python
set "VENV_DIR=%BAT_DIR%venv"

:: Verificar si el entorno virtual (venv) ya existe
if not exist "%VENV_DIR%\Scripts\activate.bat" (
    echo [INFO] Creando entorno virtual inicial...
    python -m venv "%VENV_DIR%"
    if errorlevel 1 (
        echo [ERROR] No se pudo crear el entorno virtual. Asegurate de tener Python instalado y en el PATH.
        pause
        exit /b
    )
    
    echo [INFO] Instalando dependencias...
    call "%VENV_DIR%\Scripts\activate.bat"
    pip install -r "%BAT_DIR%requirements.txt"
    if errorlevel 1 (
        echo [ERROR] Ocurrio un error al instalar las dependencias.
        pause
        exit /b
    )
) else (
    call "%VENV_DIR%\Scripts\activate.bat"
)

:: Ejecutar el script de conversion pasando todos los argumentos
python "%BAT_DIR%convert.py" %*

endlocal
