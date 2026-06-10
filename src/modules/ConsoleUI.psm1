# ConsoleUI.psm1
# Hanterar all inmatning och utmatning i konsolen.
# Modulen innehåller ingen spellogik, ingen poänglogik och ingen sparlogik.


# Rensar terminalen innan en ny vy visas.
function Clear-Screen {
    Clear-Host
}


# Visar spelets enkla rubrik.
function Show-Header {
    Write-Host "SECURITY ESCAPE ROOM CLI"
    Write-Host "========================"
    Write-Host ""
}


# Visar huvudmenyn och returnerar användarens val till GameEngine.
function Show-MainMenu {
    param(
        [bool]$HasSaveGame
    )

    Clear-Screen
    Show-Header

    Write-Host "1. Nytt spel"

    