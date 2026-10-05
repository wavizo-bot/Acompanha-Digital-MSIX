#!/bin/bash
# Build script for Acompanha Digital MSIX package
# Run this on a Windows machine with Visual Studio 2022 and Windows App SDK 1.5+ installed

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST_DIR="$PROJECT_DIR/host"
MSIX_DIR="$PROJECT_DIR"

echo "=========================================="
echo "Building Acompanha Digital MSIX Package"
echo "=========================================="

# Restore NuGet packages
echo "Restoring NuGet packages..."
dotnet restore "$HOST_DIR/AcompanhaDigital.csproj"

# Build the project
echo "Building project..."
dotnet build "$HOST_DIR/AcompanhaDigital.csproj" -c Release -r win10-x64

# Publish the MSIX package
echo "Publishing MSIX package..."
dotnet publish "$HOST_DIR/AcompanhaDigital.csproj" -c Release -r win10-x64 --self-contained true /p:EnableMsixTooling=true /p:WindowsPackageType=MSIX

echo ""
echo "=========================================="
echo "Build complete!"
echo "MSIX package location: $HOST_DIR/bin/Release/net8.0-windows10.0.19041.0/win10-x64/AppX/"
echo "=========================================="
echo ""
echo "Next steps for Microsoft Partner Center submission:"
echo "1. Sign the MSIX package with your certificate"
echo "2. Run Windows App Certification Kit (WACK) to validate"
echo "3. Upload to Partner Center with the following identity:"
echo "   - Package Name: wavizo.AcompanhaDigital"
echo "   - Publisher: CN=57BB464E-553F-45B6-A4ED-B253157408EB"
echo "   - Publisher Display Name: wavizo"
echo "   - Package Family Name: wavizo.AcompanhaDigital_c5p81jb0en0bm"
echo "   - Store ID: 9NM4GZ6VH86N"
echo ""
echo "Required store assets (prepare separately):"
echo "- Screenshots (min 2, recommended 6+): 1366x768, 1920x1080, etc."
echo "- Promotional images: 1024x500 (feature graphic)"
echo "- Privacy policy URL (host politica-privacidade.html publicly)"
echo "- App description (use store_listing_text.txt as reference)"