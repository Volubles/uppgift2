# Test-ConsoleUI.ps1
# Minimal test av ConsoleUI.psm1.
# Kör från projektroten:
# .\tests\Test-ConsoleUI.ps1

$ErrorActionPreference = "Stop"

# Sökväg till modulen.
$modulePath = ".\src\modules\ConsoleUI.psm1"

# Kontrollera att filen finns.
if (-not (Test-Path $modulePath)) {
    throw "ConsoleUI.psm1 saknas."
}

# Importera modulen.
Import-Module $modulePath -Force

# Kontrollera att funktionerna finns.
$functions = @(
    "Clear-Screen",
    "Show-Header",
    "Show-MainMenu",
    "Get-PlayerName",
    "Show-Room",
    "Get-PlayerChoice",
    "Show-Feedback",
    "Show-GameOver",
    "Show-Message",
    "Wait-ForEnter"
)

foreach ($function in $functions) {
    if (-not (Get-Command $function -ErrorAction SilentlyContinue)) {
        throw "Funktionen saknas: $function"
    }

    Write-Host "OK: $function"
}

# Fake-data för att testa Show-Room.
$fakeSaveGame = [pscustomobject]@{
    PlayerName = "Testspelare"
    Score = 1
}

$fakeRoom = [pscustomobject]@{
    Title = "Testrum"
    Description = "Detta är ett testscenario."
    Options = @(
        "Alternativ 1",
        "Alternativ 2",
        "Alternativ 3"
    )
}

# Testa enkla utskriftsfunktioner.
Show-Header
Show-Room -Room $fakeRoom -SaveGame $fakeSaveGame
Show-Feedback -IsCorrect $true -FeedbackText "Test av rätt feedback."
Show-Feedback -IsCorrect $false -FeedbackText "Test av fel feedback."
Show-Message -Message "Test av vanligt meddelande."

Write-Host ""
Write-Host "ConsoleUI-test klart utan fel."