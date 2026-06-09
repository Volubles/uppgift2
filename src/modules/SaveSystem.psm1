#   SaveSystem.psm1
#   Hanterar spara/ladda sessioner i data/savegame.json

#   Hjälpfunktion för att få sökvägen till savegame.json
function Get-SavePath {
    return Join-Path $PSScriptRoot "..\..\data\savegame.json"
}

#   Funktionen tar emot ett SaveGame-objekt och sparar det i data/savegame.json
#   Att läggs i ett try-block då filskrivning av olika anledningar kan misslyckas.
function Save-Game {
    #savePath = Get-SavePath
    try {
        # Skapar mappen data om den av någon anledning inte finns
        $dir = Split-Path $savePath
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir | Out-Null
        }
#   Översätter SaveGame-objektet till JSON-format
        $json = ConvertTo-Json -InputObject $SaveGame -Depth 4
        Set-Content -Path $savePath -Value $json -Encoding UTF8 -ErrorAction Stop
    }
#   Här fångas eventuella fel som kan uppstå under filskrivningen och kastar det till den som anropar funktionen som kan visa ett användarvänligt felmeddelande.
    catch {
        throw "Kunde inte spara spelet: $_"
    }
}