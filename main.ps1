# main.ps1
# Startfil för Security Escape Room CLI.
# Kör detta skript för att starta spelet och utbildningen.

# Säkerställ UTF-8 utmatning i konsolen för svenska tecken (å, ä, ö)
if ($PSVersionTable.PSVersion.Major -ge 5) {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::InputEncoding = [System.Text.Encoding]::UTF8
}

$enginePath = Join-Path $PSScriptRoot "src\modules\GameEngine.psm1"

if (-not (Test-Path $enginePath)) {
    Write-Host "Kritiskt fel: Kunde inte hitta spelmotorn på: $enginePath" -ForegroundColor Red
    Exit 1
}

try {
    # Importera spelmotorn och starta
    Import-Module $enginePath -Force
    Start-Game
}
catch {
    Write-Host "Ett oväntat fel uppstod vid körning av spelet: $_" -ForegroundColor Red
    Write-Host "Kontrollera att alla filer finns i rätt kataloger enligt README.md." -ForegroundColor Yellow
}

