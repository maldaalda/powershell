# 1. Admin práva
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$usbPath = Split-Path -Parent $PSCommandPath
$appsPath = Join-Path $usbPath "apps"
Write-Host "--- Start OFFLINE instalace z USB ---" -ForegroundColor Cyan

# 2. Napájení - Vysoký výkon
Write-Host "Nastavuji vysoký výkon..." -ForegroundColor Yellow
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /x -hibernate-timeout-ac 0
powercfg /x -standby-timeout-ac 0

# Pomocná funkce pro tichou instalaci
function Install-App {
    param($FileName, $Arguments)
    $fullPath = Join-Path $appsPath $FileName
    if (Test-Path $fullPath) {
        Write-Host "Instaluji: $FileName" -ForegroundColor White
        Start-Process -FilePath $fullPath -ArgumentList $Arguments -Wait
    } else {
        Write-Warning "Soubor nenalezen: $FileName"
    }
}

# 3. Instalace z EXE/MSI (Silent parametry)
Install-App "ChromeSetup.exe" "/silent /install"
Install-App "Firefox_Installer.exe" "-ms"
Install-App "7zip.exe" "/S"
Install-App "vlc.exe" "/S"
Install-App "dotnet_desktop.exe" "/quiet /norestart"
Install-App "dotnet_framework.exe" "/q /norestart"
Install-App "ninite.exe"
Install-App "office_setup.exe" "/configure" # Vyžaduje .xml, pokud je to ODT

# 4. ESET
Write-Host "Instaluji ESET..." -ForegroundColor Magenta
$esetFile = Join-Path $usbPath "eset\eset_installer.exe"
if (Test-Path $esetFile) {
    Start-Process -FilePath $esetFile -ArgumentList "/silent /noui" -Wait
}

# 5. TeamViewer + Heslo
Install-App "teamviewer_setup.exe" "/S"
Write-Host "Nastavuji heslo TeamViewer..." -ForegroundColor Yellow
$tvPath = "${env:ProgramFiles}\TeamViewer\TeamViewer.exe"
if (Test-Path $tvPath) {
    & $tvPath -assign --password "7465"
}

# 6. DOAS
Write-Host "Instaluji DOAS..." -ForegroundColor Magenta
$doasFolder = Join-Path $usbPath "doas"
if (Test-Path $doasFolder) {
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$($doasFolder)\rsysmgr-3.0.16.0.msi`" /quiet /norestart" -Wait
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$($doasFolder)\doas-3.877.3.0.msi`" /quiet /norestart" -Wait
    & (Join-Path $doasFolder "doas_bez_domeny.bat")
}

Write-Host "--- HOTOVO! ---" -ForegroundColor Green
pause