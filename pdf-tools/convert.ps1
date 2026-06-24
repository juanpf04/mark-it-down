param(
    [Parameter(Position = 0, Mandatory = $false)]
    [string]$InputPath,

    [Alias('o')]
    [Parameter(Mandatory = $false)]
    [string]$OutputFile
)

$ApiKey = $env:SECURITY_CUSTOMGLOBALAPIKEY
$ApiUrl = "http://localhost:8080/api/v1/convert/pdf/markdown"

function Get-UniqueFilename {
    param (
        [string]$Path
    )
    
    if (-Not (Test-Path -LiteralPath $Path)) {
        return $Path
    }
    
    $directory = [System.IO.Path]::GetDirectoryName($Path)
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $extension = [System.IO.Path]::GetExtension($Path)
    
    if ([string]::IsNullOrEmpty($extension)) {
        $extension = ".md"
    }
    
    $counter = 1
    while ($true) {
        $newPath = Join-Path -Path $directory -ChildPath "$baseName ($counter)$extension"
        if (-Not (Test-Path -LiteralPath $newPath)) {
            return $newPath
        }
        $counter++
    }
}

$interactive = $false

if ([string]::IsNullOrEmpty($InputPath)) {
    $interactive = $true
    Write-Host "=== Stirling PDF Local Converter ===" -ForegroundColor Cyan
    $InputPath = Read-Host "Introduce o arrastra la ruta del archivo a convertir"
    $InputPath = $InputPath.Trim('"', "'", ' ')
    
    $OutputFile = Read-Host "`nIntroduce la ruta de salida (o presiona Enter para usar el mismo directorio)"
    $OutputFile = $OutputFile.Trim('"', "'", ' ')
    
    if ([string]::IsNullOrEmpty($InputPath)) {
        Write-Host "No se proporcionó ningún archivo." -ForegroundColor Red
        pause
        exit 1
    }
}

if (-Not (Test-Path -LiteralPath $InputPath -PathType Leaf)) {
    Write-Host "`nError: No se encontró el archivo '$InputPath'." -ForegroundColor Red
    if ($interactive) { pause } else { Start-Sleep -Seconds 3 }
    exit 1
}

$InputPath = (Get-Item -LiteralPath $InputPath).FullName

if ([string]::IsNullOrEmpty($OutputFile)) {
    $directory = [System.IO.Path]::GetDirectoryName($InputPath)
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($InputPath)
    $OutputFile = Join-Path -Path $directory -ChildPath "$baseName.md"
} elseif (-Not $OutputFile.ToLower().EndsWith(".md")) {
    $OutputFile += ".md"
}

# Asegurar que la ruta de salida es absoluta
if (-Not [System.IO.Path]::IsPathRooted($OutputFile)) {
    $OutputFile = Join-Path -Path (Get-Location).Path -ChildPath $OutputFile
}

$OutputFile = Get-UniqueFilename -Path $OutputFile

Write-Host "`nConvirtiendo '$InputPath' a Markdown mediante Stirling PDF API..." -ForegroundColor Yellow

try {
    $headers = @{}
    if (-Not [string]::IsNullOrEmpty($ApiKey)) {
        $headers["X-API-KEY"] = $ApiKey
    }

    $form = @{
        fileInput = Get-Item -LiteralPath $InputPath
    }

    # Crear directorio de salida si no existe
    $outputDir = [System.IO.Path]::GetDirectoryName($OutputFile)
    if (-Not (Test-Path -LiteralPath $outputDir)) {
        New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
    }

    Invoke-RestMethod -Uri $ApiUrl -Method Post -Headers $headers -Form $form -OutFile $OutputFile
    
    Write-Host "`n¡Éxito! Archivo guardado en '$OutputFile'" -ForegroundColor Green
} catch {
    Write-Host "`nError durante la conversión:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    if ($interactive) { pause } else { Start-Sleep -Seconds 3 }
    exit 1
}

if ($interactive) {
    Write-Host ""
    pause
} else {
    Start-Sleep -Seconds 3
}
