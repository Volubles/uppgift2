# Test-MVP.ps1
# Enkel kontroll av att spelets viktigaste delar går att ladda.
# Kör från projektroten:
# .\tests\Test-MVP.ps1

$ErrorActionPreference = "Stop"

$modules = @(
    ".\src\modules\RoomProvider.psm1",
    ".\src\modules\SaveSystem.psm1",
    ".\src\modules\ConsoleUI.psm1"
)

foreach ($module in $modules) {
    if (-not (Test-Path $module)) {
        throw "Modul saknas: $module"
    }

    Import-Module $module -Force -Global
    Write-Host "OK: $module"
}

$rooms = Get-Rooms
if ($rooms.Count -eq 0) {
    throw "rooms.json innehåller inga rum."
}

$firstRoom = Get-RoomById -RoomId "room1"
if ($null -eq $firstRoom) {
    throw "Kunde inte hitta room1."
}

$gameEngine = ".\src\modules\GameEngine.psm1"
if (-not (Test-Path $gameEngine)) {
    throw "Modul saknas: $gameEngine"
}

Import-Module $gameEngine -Force -Global
Write-Host "OK: $gameEngine"

if (-not (Get-Command Start-Game -ErrorAction SilentlyContinue)) {
    throw "Start-Game saknas."
}

Write-Host ""
Write-Host "MVP-test klart utan fel."
