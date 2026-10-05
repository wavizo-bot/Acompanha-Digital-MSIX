# ========================================================================
# Build do pacote MSIX da Acompanha Digital - SEM Visual Studio
# Requisitos: .NET SDK 8 (dotnet), Windows 10/11 SDK (makeappx/signtool)
# Uso:
#   powershell -ExecutionPolicy Bypass -File msix\build-msix.ps1
#   powershell -File msix\build-msix.ps1 -Thumbprint <certificado>
# ========================================================================
param(
    [string]$Dotnet = "",
    [string]$Thumbprint = "93F250E24074A804684F9E390D36DBB662DF27AF"
)

$ErrorActionPreference = "Stop"
$msixDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$hostDir = Join-Path $msixDir "host"
$distDir = Join-Path $msixDir "dist"
$layout  = Join-Path $env:TEMP "ad-msix-layout"

Write-Host "=========================================="
Write-Host "Acompanha Digital - build MSIX"
Write-Host "=========================================="

# ---- 1. localizar ferramentas --------------------------------------
if (-not $Dotnet) {
    $cmd = Get-Command dotnet -ErrorAction SilentlyContinue
    if ($cmd) { $Dotnet = $cmd.Source }
    elseif (Test-Path "$env:USERPROFILE\.dotnet\dotnet.exe") { $Dotnet = "$env:USERPROFILE\.dotnet\dotnet.exe" }
    else { throw ".NET SDK nao encontrado (instale em https://dot.net)" }
}
$kits = Get-ChildItem "C:\Program Files (x86)\Windows Kits\10\bin" -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending | Where-Object { Test-Path "$($_.FullName)\x64\makeappx.exe" } | Select-Object -First 1
if (-not $kits) { throw "Windows SDK (makeappx.exe) nao encontrado" }
$makeappx = Join-Path $kits.FullName "x64\makeappx.exe"
$signtool = Join-Path $kits.FullName "x64\signtool.exe"
Write-Host "dotnet:   $Dotnet"
Write-Host "makeappx: $makeappx"

# ---- 2. versao lida do manifesto ------------------------------------
$manifest = Join-Path $msixDir "Package.appxmanifest"
$xml = [xml](Get-Content $manifest -Raw)
$versao = $xml.Package.Identity.Version
$nome   = $xml.Package.Identity.Name
Write-Host "identidade: $nome  versao: $versao"

# ---- 3. compilar o host --------------------------------------------
Write-Host "`nCompilando host (net472 + WebView2)..."
& $Dotnet build (Join-Path $hostDir "AcompanhaDigital.csproj") -c Release -p:Platform=x64 -v minimal
if ($LASTEXITCODE -ne 0) { throw "Falha no dotnet build" }
$out = Join-Path $hostDir "bin\x64\Release\net472"

# ---- 4. montar o layout --------------------------------------------
Write-Host "`nMontando layout do pacote..."
if (Test-Path $layout) { Remove-Item $layout -Recurse -Force }
New-Item -ItemType Directory -Path "$layout\assets" -Force | Out-Null
Copy-Item $manifest "$layout\AppxManifest.xml"
Copy-Item (Join-Path $msixDir "assets\*") "$layout\assets\" -Force
Copy-Item (Join-Path $out "www") "$layout\www" -Recurse -Force
foreach ($f in @("AcompanhaDigital.exe","AcompanhaDigital.exe.config",
                 "Microsoft.Web.WebView2.Core.dll","Microsoft.Web.WebView2.Wpf.dll",
                 "Microsoft.Web.WebView2.WinForms.dll","WebView2Loader.dll")) {
    Copy-Item (Join-Path $out $f) $layout
}
Copy-Item (Join-Path $out "runtimes") "$layout\runtimes" -Recurse -Force

# ---- 5. empacotar ---------------------------------------------------
New-Item -ItemType Directory -Path $distDir -Force | Out-Null
$msix = Join-Path $distDir "$($nome)_$($versao)_x64.msix"
Write-Host "`nEmpacotando $msix ..."
& $makeappx pack /d $layout /p $msix /o
if ($LASTEXITCODE -ne 0) { throw "makeappx falhou" }

# ---- 6. assinar e verificar ----------------------------------------
Write-Host "`nAssinando com o certificado $Thumbprint ..."
& $signtool sign /sha1 $Thumbprint /fd SHA256 /td SHA256 /tr http://timestamp.digicert.com $msix
if ($LASTEXITCODE -ne 0) { throw "signtool sign falhou" }
& $signtool verify /pa $msix | Out-Host
if ($LASTEXITCODE -ne 0) { throw "signtool verify falhou" }

$mb = [math]::Round((Get-Item $msix).Length / 1MB, 2)
Write-Host "`n=========================================="
Write-Host "PRONTO: $msix ($mb MB)"
Write-Host "Teste local: Add-AppxPackage -Path `"$msix`""
Write-Host "Upload: Partner Center > Apps > Acompanha Digital > + Submissoes > Packages"
Write-Host "=========================================="
