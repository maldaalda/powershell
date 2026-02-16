# 1. Vynucení TLS 1.2 pro bezpečné stažení z GitHubu
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "--- Oprava Winget rozhraní (Update AppInstaller) ---" -ForegroundColor Yellow

# 2. Stažení nejnovějšího balíčku Winget přímo od Microsoftu
$url = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$tempPath = "$env:TEMP\winget_update.msixbundle"

try {
    Invoke-WebRequest -Uri $url -OutFile $tempPath -ErrorAction Stop
    Add-AppxPackage -Path $tempPath -ErrorAction Stop
    Write-Host "Winget byl úspěšně aktualizován." -ForegroundColor Green
} catch {
    Write-Host "Chyba při aktualizaci Wingetu: $_" -ForegroundColor Red
}

# 3. Reset zdrojů po aktualizaci
winget source reset --force
Start-Sleep -Seconds 5

# 4. Seznam aplikací k instalaci
$apps = @(
    "Google.Chrome",
    "VideoLAN.VLC",
    "7zip.7zip",
    "Mozilla.Firefox",
    "Adobe.Acrobat.Reader.64-bit",
    "Microsoft.DotNet.Framework.DeveloperPack_4",
    "Dell.CommandUpdate.Universal",
    "Microsoft.DotNet.DesktopRuntime.7",
    "TeamViewer.TeamViewer.Host"
)

foreach ($app in $apps) {
    Write-Host "Instaluji: $app" -ForegroundColor Cyan
    winget install --id $app --silent --accept-source-agreements --accept-package-agreements --force
}

Write-Host "--- Vše hotovo! ---" -ForegroundColor Green
