@echo off
setlocal

:: Verificar si se proporcionó un archivo (Drag & Drop)
if "%~1"=="" (
    echo No se proporciono ningun archivo. Por favor, arrastra un archivo sobre este script.
    pause
    exit /b
)

:: Obtener el directorio donde se encuentra este archivo .bat
set "BAT_DIR=%~dp0"
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
    
    echo [INFO] Instalando markitdown...
    call "%VENV_DIR%\Scripts\activate.bat"
    pip install "markitdown[all]"
    if errorlevel 1 (
        echo [ERROR] Ocurrio un error al instalar markitdown.
        pause
        exit /b
    )
) else (
    call "%VENV_DIR%\Scripts\activate.bat"
)

:: Ejecutar el script de conversion pasando la ruta absoluta del archivo
python "%BAT_DIR%convert.py" "%~1"

:: Pausar solo si hubo algun error, para que la ventana se cierre rapido si todo sale bien
if errorlevel 1 (
    pause
)

endlocal
