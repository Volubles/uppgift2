#   SaveSystem.psm1
#   Hanterar spara/ladda sessioner i data/savegame.json

#   Hjälpfunktion för att få sökvägen till savegame.json
function Get-SavePath {
    return Join-Path $PSScriptRoot "..\..\data\savegame.json"
}