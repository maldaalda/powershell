# Skript pro automatickou instalaci aplikací
$apps = @(
    "Google.Chrome",
    "VideoLAN.VLC",
    "7zip.7zip"
)

foreach ($app in $apps) {
    Write-Host "Instaluji: $app" -ForegroundColor Cyan
    winget install --id $app --silent --accept-source-agreements --accept-package-agreements
}

Write-Host "Hotovo! Vše je nainstalováno." -ForegroundColor Green

