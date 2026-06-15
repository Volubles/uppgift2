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

        # Introtext innan spelet startar
    Clear-Host
    Write-Host "VÄLKOMMEN TILL SECURITY ESCAPE ROOM" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Vi på IT vill påminna om att våra tekniska system bara är hälften av företagets skydd, den andra hälften är du." -ForegroundColor White
    Write-Host "Eftersom cyberhoten blir allt smartare är denna korta IT-säkerhetsutbildning obligatorisk för att vi tillsammans ska kunna säkra vår dagliga drift." -ForegroundColor White
    Write-Host "Tack för att du tar dig tiden och hjälper oss att hålla verksamheten trygg!"
    Write-Host ""
    Write-Host "I det här spelet kommer du att få läsa teori och sedan lösa säkerhetsrelaterade situationer." -ForegroundColor White
    Write-Host "Du kommer att få träna på exempelvis phishing, lösenord och säker hantering av USB-enheter." -ForegroundColor White
    Write-Host ""
    Write-Host "Tryck Enter för att gå vidare till huvudmenyn..." -ForegroundColor Green -NoNewline | Out-Null
    Read-Host

    Start-Game
}
catch {
    Write-Host "Ett oväntat fel uppstod vid körning av spelet: $_" -ForegroundColor Red
    Write-Host "Kontrollera att alla filer finns i rätt kataloger enligt README.md." -ForegroundColor Yellow
}