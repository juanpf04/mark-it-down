@echo off
setlocal

:: Wrapper para Drag & Drop / CLI hacia el script de PowerShell

:: Obtener el directorio donde se encuentra este archivo .bat
set "BAT_DIR=%~dp0"

:: Ejecutar el script de PowerShell pasando todos los argumentos (%*)
:: ExecutionPolicy Bypass garantiza que se pueda ejecutar sin problemas de permisos locales
powershell -ExecutionPolicy Bypass -NoProfile -File "%BAT_DIR%convert.ps1" %*

endlocal
