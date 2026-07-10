# ============================================================
# restaurar_entorno.ps1
# Restaura los archivos CSV a la carpeta de entrada para
# poder ejecutar el paquete SSIS nuevamente.
# ============================================================

$base     = Split-Path -Parent $PSScriptRoot
$entrada  = Join-Path $base "data\entrada"
$procesados = Join-Path $base "data\procesados"
$errores  = Join-Path $base "data\errores"
$backup   = Join-Path $base "data\backup"

# Crear carpetas si no existen
@($entrada, $procesados, $errores, $backup) | ForEach-Object {
    if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null }
}

# 1. Mover ZIPs de procesados a backup (limpiar procesados)
Get-ChildItem $procesados -Filter "*.zip" | ForEach-Object {
    Move-Item $_.FullName $backup -Force
    Write-Host "ZIP movido a backup: $($_.Name)"
}

# 2. Mover CSVs de procesados de vuelta a entrada
Get-ChildItem $procesados -Filter "*.csv" | ForEach-Object {
    Move-Item $_.FullName $entrada -Force
    Write-Host "Restaurado a entrada: $($_.Name)"
}

# 3. Limpiar archivos de errores anteriores
Get-ChildItem $errores -Filter "*.csv" | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Host "Limpiado de errores: $($_.Name)"
}

Write-Host ""
Write-Host "Entorno restaurado. Ya puedes volver a ejecutar CargaVentas.dtsx" -ForegroundColor Green
