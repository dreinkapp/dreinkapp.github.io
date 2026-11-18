<#
  Actualiza los datos del instalador en index.html (version, nombre de archivo,
  tamano y SHA-256). Ejecutar despues de cada build:win.

    powershell -ExecutionPolicy Bypass -File site\actualizar-instalador.ps1
    powershell -ExecutionPolicy Bypass -File site\actualizar-instalador.ps1 -Exe dist\Dreink-1.0.0-setup.exe
#>

param(
  [string]$Exe = (Join-Path $PSScriptRoot '..\dist\Dreink-1.0.0-setup.exe'),
  [string]$Index = (Join-Path $PSScriptRoot 'index.html')
)

$ErrorActionPreference = 'Stop'
$es = [System.Globalization.CultureInfo]::GetCultureInfo('es-ES')
$dash = [char]0x2014

if (-not (Test-Path -LiteralPath $Exe)) {
  throw "No se encuentra el instalador: $Exe"
}
if (-not (Test-Path -LiteralPath $Index)) {
  throw "No se encuentra la pagina: $Index"
}

$item = Get-Item -LiteralPath $Exe
$file = $item.Name
$sha = (Get-FileHash -LiteralPath $Exe -Algorithm SHA256).Hash

if ($file -notmatch '^Dreink-(?<v>\d+\.\d+\.\d+)-setup\.exe$') {
  throw "El nombre no sigue el patron Dreink-<version>-setup.exe: $file"
}
$version = $Matches['v']

$bytes = $item.Length.ToString('N0', $es)
$mib = ($item.Length / 1MB).ToString('0.0', $es)
$size = "$bytes bytes ($mib MiB)"
$shortSize = "$mib MiB"

$html = Get-Content -LiteralPath $Index -Raw -Encoding UTF8

$replacements = @(
  @{ Pattern = "sha256: '[0-9A-Fa-f]{64}'"; Value = "sha256: '$sha'" },
  @{ Pattern = "size: '[^']*'"; Value = "size: '$size'" },
  @{ Pattern = "shortSize: '[^']*'"; Value = "shortSize: '$shortSize'" },
  @{ Pattern = "file: '[^']*'"; Value = "file: '$file'" },
  @{ Pattern = "version: '[^']*'"; Value = "version: '$version'" },
  @{ Pattern = 'id="sha">[^<]*<'; Value = "id=`"sha`">$sha<" },
  @{ Pattern = 'id="download-size">[^<]*<'; Value = "id=`"download-size`">$shortSize<" },
  @{ Pattern = 'id="hash-size">[^<]*<'; Value = "id=`"hash-size`">$size<" },
  @{ Pattern = 'id="fact-size">[^<]*<'; Value = "id=`"fact-size`">$shortSize<" },
  @{ Pattern = 'id="version-tag">[^<]*<'; Value = "id=`"version-tag`">$version<" },
  @{ Pattern = 'id="fact-version">[^<]*<'; Value = "id=`"fact-version`">$version<" },
  @{ Pattern = 'id="eyebrow-version">[^<]*<'; Value = "id=`"eyebrow-version`">$version<" },
  @{ Pattern = '(<(?:code|span)[^>]*class="install-file"[^>]*>)[^<]*(<)'; Value = "`$1$file`$2" }
)

foreach ($r in $replacements) {
  if (-not [regex]::IsMatch($html, $r.Pattern)) {
    Write-Warning "No se encontro el patron: $($r.Pattern)"
    continue
  }
  $html = [regex]::Replace($html, $r.Pattern, $r.Value)
}

$html = [regex]::Replace(
  $html,
  '<title>Dreink [^<]*</title>',
  "<title>Dreink $version $dash Descargar para Windows</title>"
)

[System.IO.File]::WriteAllText($Index, $html, (New-Object System.Text.UTF8Encoding($false)))

Write-Host 'Pagina actualizada:'
Write-Host "  archivo   $file"
Write-Host "  version   $version"
Write-Host "  tamano    $size"
Write-Host "  sha256    $sha"
