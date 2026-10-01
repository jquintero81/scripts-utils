# Script para documentar proyecto Spring Boot en archivo Markdown
# Uso: .\DocumentarProyecto.ps1 -RutaProyecto "C:\ruta\a\tu\proyecto" -ArchivoSalida "documentacion.md"

param(
    [Parameter(Mandatory=$true)]
    [string]$RutaProyecto,
    
    [Parameter(Mandatory=$false)]
    [string]$ArchivoSalida = "documentacion.md",
    
    [Parameter(Mandatory=$false)]
    [array]$ExtensionesIncluir = @("*.java", "*.xml", "*.properties", "*.yml", "*.yaml", "*.sql", "*.json"),
    
    [Parameter(Mandatory=$false)]
    [array]$DirectoriosExcluir = @(".idea", ".git", ".vscode", "target", "node_modules", ".gradle", "build", ".m2")
)

# Validar que la ruta existe
if (-not (Test-Path $RutaProyecto)) {
    Write-Error "La ruta del proyecto no existe: $RutaProyecto"
    exit 1
}

# Crear o limpiar el archivo de salida
$rutaSalida = Join-Path (Get-Location) $ArchivoSalida
if (Test-Path $rutaSalida) {
    Remove-Item $rutaSalida -Force
}

# Crear archivo y agregar encabezado
$fecha = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
$contenido = @"
# Documentación del Proyecto Spring Boot

**Generado:** $fecha
**Ruta del proyecto:** $RutaProyecto

---

"@

Add-Content -Path $rutaSalida -Value $contenido -Encoding UTF8

# Obtener todos los archivos según las extensiones especificadas
$archivos = @()
foreach ($extension in $ExtensionesIncluir) {
    $archivos += Get-ChildItem -Path $RutaProyecto -Filter $extension -Recurse -File -ErrorAction SilentlyContinue
}

# Filtrar archivos: excluir directorios ocultos y directorios especificados
$archivosFiltratos = @()
foreach ($archivo in $archivos) {
    $rutaRelativa = $archivo.FullName.Replace($RutaProyecto, "").TrimStart("\")
    
    # Verificar si el archivo está en un directorio excluido
    $excluir = $false
    foreach ($dirExcluir in $DirectoriosExcluir) {
        if ($rutaRelativa -match "^$([regex]::Escape($dirExcluir))[\\/]" -or $rutaRelativa -match "[\\/]$([regex]::Escape($dirExcluir))[\\/]") {
            $excluir = $true
            break
        }
    }
    
    # Verificar si alguna parte de la ruta es un archivo/directorio oculto
    $partes = $rutaRelativa -split "[\\/]"
    foreach ($parte in $partes) {
        if ($parte.StartsWith(".")) {
            $excluir = $true
            break
        }
    }
    
    if (-not $excluir) {
        $archivosFiltratos += $archivo
    }
}

# Ordenar archivos por ruta
$archivosFiltratos = $archivosFiltratos | Sort-Object FullName

if ($archivosFiltratos.Count -eq 0) {
    Write-Warning "No se encontraron archivos con las extensiones especificadas (después de filtrar directorios excluidos)."
    Add-Content -Path $rutaSalida -Value "No se encontraron archivos para documentar." -Encoding UTF8
    exit 0
}

Write-Host "Se encontraron $($archivosFiltratos.Count) archivos. Procesando..." -ForegroundColor Green

# Procesar cada archivo
$contador = 0
foreach ($archivo in $archivosFiltratos) {
    $contador++
    $rutaRelativa = $archivo.FullName.Replace($RutaProyecto, "").TrimStart("\")
    
    Write-Host "[$contador/$($archivosFiltratos.Count)] Procesando: $rutaRelativa" -ForegroundColor Cyan
    
    try {
        # Leer contenido del archivo
        $contenidoArchivo = Get-Content -Path $archivo.FullName -Raw -Encoding UTF8 -ErrorAction Stop
        
        # Determinar lenguaje para el bloque de código
        $extension = $archivo.Extension.ToLower().TrimStart(".")
        $lenguaje = switch ($extension) {
            "java" { "java" }
            "xml" { "xml" }
            "properties" { "properties" }
            "yml" { "yaml" }
            "yaml" { "yaml" }
            "sql" { "sql" }
            "json" { "json" }
            default { "text" }
        }
        
        # Agregar al archivo de salida
        $bloque = "## $rutaRelativa`n`n``````$lenguaje`n$contenidoArchivo`n``````n`n---`n`n"
        
        Add-Content -Path $rutaSalida -Value $bloque -Encoding UTF8
    }
    catch {
        Write-Warning "Error al procesar $rutaRelativa : $_"
        Add-Content -Path $rutaSalida -Value "## $rutaRelativa`n`nError al leer el archivo: $_`n`n---`n`n" -Encoding UTF8
    }
}

Write-Host "`nProceso completado exitosamente." -ForegroundColor Green
Write-Host "Archivo generado: $rutaSalida" -ForegroundColor Green
Write-Host "Total de archivos procesados: $contador" -ForegroundColor Green
