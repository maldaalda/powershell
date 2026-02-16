# 1. Povolení spouštění skriptů pro aktuální proces
Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "--- Inicializace Wingetu pro 100 PC ---" -ForegroundColor Yellow

# 2. Fix pro chybu 0x8a15005e (Reset a aktualizace zdrojů)
# Tento krok zajistí, že si Winget "sáhne" pro aktuální databázi aplikací
winget source reset --force
winget source update
Start-Sleep -Seconds 3 # Krátká pauza na rozdýchání systému

# Seznam aplikací
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
    
    # --id: přesná identifikace
    # --silent: bez ptaní
    # --accept-source-agreements: odsouhlasení podmínek Microsoftu
    # --accept-package-agreements: odsouhlasení podmínek tvůrce aplikace
    # --force: vynucení instalace i když si Winget myslí, že už tam něco je
    
    winget install --id $app --silent --accept-source-agreements --accept-package-agreements --force
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Varování: Instalace $app selhala (Error kód: $LASTEXITCODE)" -ForegroundColor Red
    } else {
        Write-Host "Úspěšně nainstalováno: $app" -ForegroundColor Green
    }
}

Write-Host "--- Hotovo! Všechny naplánované úlohy dokončeny. ---" -ForegroundColor Green
