Métodos para Verificar Hashes en Windows
1. Usando certutil (Disponible en todas las versiones de Windows)
cmd
# Sintaxis básica
certutil -hashfile [RUTA_DEL_ARCHIVO] [ALGORITMO]

# Ejemplos con diferentes algoritmos
certutil -hashfile "C:\Usuarios\Nombre\Documentos\archivo.exe" MD5
certutil -hashfile "C:\Descargas\software.zip" SHA1
certutil -hashfile "D:\Instaladores\setup.msi" SHA256
certutil -hashfile "Z:\desktoplsr.exe" SHA512

# Con rutas que contienen espacios
certutil -hashfile "C:\Mi Carpeta\Archivo con espacios.pdf" SHA256

# Verificar contra un hash conocido
certutil -hashfile archivo.iso SHA256 | findstr /i "hash_conocido"
Algoritmos disponibles con certutil:

MD5 (Message Digest 5)

SHA1 (Secure Hash Algorithm 1)

SHA256 (Secure Hash Algorithm 256-bit)

SHA384 (Secure Hash Algorithm 384-bit)

SHA512 (Secure Hash Algorithm 512-bit)

2. Usando PowerShell (Windows 7 y superiores)
powershell
# Sintaxis básica
Get-FileHash -Path [RUTA_DEL_ARCHIVO] -Algorithm [ALGORITMO]

# Ejemplos
Get-FileHash -Path "C:\Usuarios\Nombre\Documentos\archivo.exe" -Algorithm MD5
Get-FileHash -Path "C:\Descargas\software.zip" -Algorithm SHA1
Get-FileHash -Path "D:\Instaladores\setup.msi" -Algorithm SHA256
Get-FileHash -Path "Z:\desktoplsr.exe" -Algorithm SHA512
Get-FileHash -Path "Z:\desktoplsr.exe" -Algorithm SHA384
Get-FileHash -Path "Z:\desktoplsr.exe" -Algorithm SHA512

# Formato simplificado
Get-FileHash Z:\desktoplsr.exe -Algorithm SHA512

# Mostrar solo el hash
(Get-FileHash -Path "Z:\desktoplsr.exe" -Algorithm SHA512).Hash

# Comparar con hash conocido
$hashEsperado = "A1B2C3D4E5F6..."
$hashCalculado = (Get-FileHash -Path "Z:\desktoplsr.exe" -Algorithm SHA512).Hash

if ($hashCalculado -eq $hashEsperado) {
    Write-Host "✓ El hash coincide" -ForegroundColor Green
} else {
    Write-Host "✗ El hash NO coincide" -ForegroundColor Red
}
Algoritmos disponibles con Get-FileHash:

MD5

SHA1

SHA256 (predeterminado si no se especifica)

SHA384

SHA512

MACTripleDES

RIPEMD160

3. Usando PowerShell con funciones avanzadas
powershell
# Función para verificar múltiples archivos
function Test-FileHash {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path,
        
        [Parameter(Mandatory=$true)]
        [string]$ExpectedHash,
        
        [ValidateSet("MD5","SHA1","SHA256","SHA384","SHA512")]
        [string]$Algorithm = "SHA256"
    )
    
    $actualHash = (Get-FileHash -Path $Path -Algorithm $Algorithm).Hash
    
    if ($actualHash -eq $ExpectedHash) {
        Write-Host "✅ VERIFICADO: $Path" -ForegroundColor Green
        Write-Host "   Hash: $actualHash"
        return $true
    } else {
        Write-Host "❌ ERROR: $Path" -ForegroundColor Red
        Write-Host "   Esperado: $ExpectedHash"
        Write-Host "   Obtenido: $actualHash"
        return $false
    }
}

# Uso de la función
Test-FileHash -Path "Z:\desktoplsr.exe" -ExpectedHash "abc123..." -Algorithm SHA512

# Función para comparar dos archivos
function Compare-FileHash {
    param(
        [string]$File1,
        [string]$File2,
        [string]$Algorithm = "SHA256"
    )
    
    $hash1 = (Get-FileHash -Path $File1 -Algorithm $Algorithm).Hash
    $hash2 = (Get-FileHash -Path $File2 -Algorithm $Algorithm).Hash
    
    Write-Host "Archivo 1 ($File1): $hash1"
    Write-Host "Archivo 2 ($File2): $hash2"
    
    if ($hash1 -eq $hash2) {
        Write-Host "✅ Los archivos son idénticos" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ Los archivos son diferentes" -ForegroundColor Red
        return $false
    }
}
4. Script de PowerShell para verificación completa
powershell
<#
.SYNOPSIS
    Verifica el hash de un archivo y lo compara con un valor esperado
.DESCRIPTION
    Esta función calcula el hash de un archivo y verifica si coincide con el valor esperado
.EXAMPLE
    Verify-FileIntegrity -FilePath "C:\file.exe" -ExpectedHash "abc123..." -Algorithm SHA256
#>
function Verify-FileIntegrity {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateScript({Test-Path $_})]
        [string]$FilePath,
        
        [Parameter(Mandatory=$true, Position=1)]
        [string]$ExpectedHash,
        
        [Parameter(Position=2)]
        [ValidateSet("MD5","SHA1","SHA256","SHA384","SHA512")]
        [string]$Algorithm = "SHA256",
        
        [Parameter()]
        [switch]$CaseInsensitive
    )
    
    # Calcular hash del archivo
    try {
        $actualHash = (Get-FileHash -Path $FilePath -Algorithm $Algorithm -ErrorAction Stop).Hash
    } catch {
        Write-Error "Error al calcular el hash: $_"
        return $false
    }
    
    # Comparar hashes
    if ($CaseInsensitive) {
        $comparison = [string]::Compare($actualHash, $ExpectedHash, $true)
        $match = ($comparison -eq 0)
    } else {
        $match = ($actualHash -eq $ExpectedHash)
    }
    
    # Mostrar resultados
    Write-Host ""
    Write-Host "=== VERIFICACIÓN DE INTEGRIDAD ===" -ForegroundColor Cyan
    Write-Host "Archivo:   $FilePath"
    Write-Host "Algoritmo: $Algorithm"
    Write-Host ""
    Write-Host "Hash calculado:  $actualHash"
    Write-Host "Hash esperado:   $ExpectedHash"
    Write-Host ""
    
    if ($match) {
        Write-Host "✅ INTEGRIDAD VERIFICADA" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ INTEGRIDAD COMPROMETIDA" -ForegroundColor Red
        return $false
    }
}

# Ejemplo de uso
Verify-FileIntegrity -FilePath "Z:\desktoplsr.exe" -ExpectedHash "tu_hash_aqui" -Algorithm SHA512
5. Verificación por lotes (Batch Script)
batch
@echo off
REM Script para verificar hash de múltiples archivos
setlocal enabledelayedexpansion

REM Configuración
set ALGORITHM=SHA512
set "ARCHIVO=Z:\desktoplsr.exe"
set HASH_ESPERADO=tu_hash_aqui_poner_sin_espacios

echo Verificando integridad de %ARCHIVO%...
echo Algoritmo: %ALGORITHM%
echo.

REM Calcular hash usando certutil
certutil -hashfile "%ARCHIVO%" %ALGORITHM% > hash_temp.txt

REM Extraer solo la línea del hash (segunda línea)
set /a line=0
for /f "tokens=*" %%i in (hash_temp.txt) do (
    set /a line+=1
    if !line! equ 2 set HASH_CALCULADO=%%i
)

del hash_temp.txt

echo Hash calculado:  %HASH_CALCULADO%
echo Hash esperado:   %HASH_ESPERADO%
echo.

REM Comparar (ignorando mayúsculas/minúsculas)
if /i "%HASH_CALCULADO%"=="%HASH_ESPERADO%" (
    echo ✅ EL ARCHIVO ES AUTENTICO
) else (
    echo ❌ EL ARCHIVO PODRIA ESTAR CORRUPTO O MODIFICADO
)

pause
6. Herramientas de Terceros (Alternativas)
a) 7-Zip
bash
# 7-Zip incluye utilidad CRC SHA desde la versión 16.04
# Botón derecho en archivo → 7-Zip → CRC SHA → Elegir algoritmo
b) HashCheck Shell Extension
Extensión para el Explorador de Windows

Agrega pestaña "Checksums" en propiedades del archivo

Soporte para múltiples algoritmos

c) HashTab
Similar a HashCheck

Agrega pestaña "File Hashes" en propiedades del archivo

Guía Rápida de Referencia
Comparación de Métodos
Método	Ventajas	Desventajas
certutil	Preinstalado, rápido	Formato menos limpio
PowerShell	Más limpio, más opciones	Requiere PS 4.0+
Herramientas GUI	Fácil de usar	Requiere instalación
Algoritmos Recomendados por Uso
Uso	Algoritmo Recomendado	Razón
Verificación rápida	MD5	Más rápido, pero menos seguro
Verificación de software	SHA256	Equilibrio entre velocidad y seguridad
Verificación crítica	SHA512	Máxima seguridad
Compatibilidad antigua	SHA1	Evitar cuando sea posible
Errores Comunes y Soluciones
"El sistema no puede encontrar la ruta especificada"

cmd
# Verificar que la ruta existe
dir "Z:\desktoplsr.exe"

# Usar comillas para rutas con espacios
certutil -hashfile "C:\Mi Carpeta\archivo.exe" SHA256
Hash en mayúsculas/minúsculas

powershell
# PowerShell es case-sensitive por defecto
# Usar -eq para comparación exacta
# O convertir a minúsculas:
$hash1.ToLower() -eq $hash2.ToLower()
Archivos muy grandes

powershell
# Para archivos grandes (>1GB)
Get-FileHash -Path "archivo_grande.iso" -Algorithm SHA256
# PowerShell maneja archivos grandes mejor que certutil
Consejos de Seguridad
Siempre verificar hashes de descargas

powershell
# Antes de instalar software descargado
Verify-FileIntegrity -FilePath "setup.exe" -ExpectedHash "hash-oficial"
Usar hashes de fuentes confiables

Verificar en sitio web oficial del desarrollador

No confiar en hashes de sitios de terceros

Verificar firmas digitales cuando sea posible

powershell
# Verificar firma digital
Get-AuthenticodeSignature -FilePath "archivo.exe"
Para archivos críticos, usar múltiples algoritmos

powershell
$file = "Z:\desktoplsr.exe"
Get-FileHash $file -Algorithm SHA256
Get-FileHash $file -Algorithm SHA512
Ejemplos Prácticos Completos
powershell
# Ejemplo 1: Verificar instalador descargado
$filePath = "$env:USERPROFILE\Downloads\VSCodeSetup.exe"
$expectedHash = "3A1A7B7D... (obtenido de sitio oficial)"

if (Verify-FileIntegrity -FilePath $filePath -ExpectedHash $expectedHash -Algorithm SHA256) {
    Write-Host "Proceder con la instalación..." -ForegroundColor Green
    # & $filePath
} else {
    Write-Host "NO instalar - archivo posiblemente corrupto" -ForegroundColor Red
}

# Ejemplo 2: Verificar todos los archivos en una carpeta
$folder = "C:\ArchivosImportantes"
$hashes = @{
    "documento1.pdf" = "hash1...";
    "imagen.jpg" = "hash2...";
    "datos.db" = "hash3..."
}

foreach ($file in $hashes.Keys) {
    $fullPath = Join-Path $folder $file
    if (Test-Path $fullPath) {
        Write-Host "Verificando $file..."
        Verify-FileIntegrity -FilePath $fullPath -ExpectedHash $hashes[$file] -Algorithm SHA512
    }
}