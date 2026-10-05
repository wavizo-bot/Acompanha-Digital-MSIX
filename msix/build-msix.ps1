# Build script for Acompanha Digital MSIX package
# Run this on a Windows machine with Visual Studio 2022 and Windows App SDK 1.5+ installed

param(
    [string]$Configuration = "Release",
    [string]$Platform = "x64"
)

$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$hostDir = Join-Path $projectDir "host"
$projectFile = Join-Path $hostDir "AcompanhaDigital.csproj"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Building Acompanha Digital MSIX Package" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Check prerequisites
Write-Host "`nChecking prerequisites..." -ForegroundColor Yellow
dotnet --version
dotnet workload list | Where-Object { $_ -like "*wasdk*" } | ForEach-Object { Write-Host "Found: $_" }

# Restore NuGet packages
Write-Host "`nRestoring NuGet packages..." -ForegroundColor Yellow
dotnet restore $projectFile

# Build the project
Write-Host "`nBuilding project..." -ForegroundColor Yellow
dotnet build $projectFile -c $Configuration -r win10-$Platform

# Publish the MSIX package
Write-Host "`nPublishing MSIX package..." -ForegroundColor Yellow
dotnet publish $projectFile -c $Configuration -r win10-$Platform --self-contained true /p:EnableMsixTooling=true /p:WindowsPackageType=MSIX

$outputDir = Join-Path $hostDir "bin\Release\net8.0-windows10.0.19041.0\win10-$Platform\AppX"

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Build complete!" -ForegroundColor Green
Write-Host "MSIX package location: $outputDir" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`nNext steps for Microsoft Partner Center submission:" -ForegroundColor Yellow
Write-Host "1. Sign the MSIX package with your certificate"
Write-Host "2. Run Windows App Certification Kit (WACK) to validate"
Write-Host "3. Upload to Partner Center with the following identity:"
Write-Host "   - Package Name: wavizo.AcompanhaDigital"
Write-Host "   - Publisher: CN=57BB464E-553F-45B6-A4ED-B253157408EB"
Write-Host "   - Publisher Display Name: wavizo"
Write-Host "   - Package Family Name: wavizo.AcompanhaDigital_c5p81jb0en0bm"
Write-Host "   - Store ID: 9NM4GZ6VH86N"
Write-Host ""
Write-Host "Required store assets (prepare separately):" -ForegroundColor Yellow
Write-Host "- Screenshots (min 2, recommended 6+): 1366x768, 1920x1080, etc."
Write-Host "- Promotional images: 1024x500 (feature graphic)"
Write-Host "- Privacy policy URL (host politica-privacidade.html publicly)"
Write-Host "- App description (use store_listing_text.txt as reference)"