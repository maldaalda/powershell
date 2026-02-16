# Skript pro automatickou instalaci aplikací
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
    winget install --id $app --silent --accept-source-agreements --accept-package-agreements
}

Write-Host "Hotovo! Vše je nainstalováno." -ForegroundColor Green

