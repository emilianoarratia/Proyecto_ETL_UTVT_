# Detecta automáticamente la carpeta raíz del proyecto (donde está este script)
$Proyecto = Split-Path -Parent $PSScriptRoot

$CarpetaProcesados = Join-Path $Proyecto "data\procesados"
$Origen  = Join-Path $CarpetaProcesados "*"
$Destino = Join-Path $CarpetaProcesados ("Procesados_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".zip")

if (!(Test-Path $CarpetaProcesados)) {
    New-Item -ItemType Directory -Path $CarpetaProcesados | Out-Null
}

# Solo comprimir si hay archivos CSV (no ZIPs previos)
$archivos = Get-ChildItem $CarpetaProcesados -Filter "*.csv"
if ($archivos.Count -gt 0) {
    Compress-Archive -Path $Origen -DestinationPath $Destino -Force
    Write-Host "ZIP generado: $Destino"
} else {
    Write-Host "No hay archivos CSV en procesados para comprimir."
}