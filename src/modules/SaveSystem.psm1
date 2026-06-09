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

#   Funktionen läser in från savegame.json och översätter det till ett SaveGame-objekt
#   Om filen inte finns returneras $null, vilket indikerar att det inte finns någon sparad session.
function Load-Game {
    $savePath = Get-SavePath
    if (-not (Test-Path $savePath)) {
        return $null
    }

#   -Raw läser in hela filen som en enda sträng, annars skulle Get-Content returnera en array av rader.
    try {
        $json = Get-Content -Raw -Path $savePath -Encoding UTF8 -ErrorAction Stop
        $saveGame = ConvertFrom-Json $json -ErrorAction Stop

#   Valideringskontroll för att säkerställa att det inlästa objektet har alla nödvändiga fält.
        $requiredFields = @("PlayerName", "CurrentRoomId", "Score", "IsCompleted")
        foreach ($field in $requiredFields) {
            if ($null -eq $saveGame.PSObject.Properties[$field]) {
                throw "Sparfilen saknar det obligatoriska fältet '$field'."
            }
        }
        return $saveGame
    }
    catch {
        throw "Kunde inte ladda spelet: $_"
    }
}

#   Rensar sparfilen när spelet är avklarat så att man ej kan "forsätta" ett avklarat spel.
#   -Force tar bort utan att fråga och -ErrorAction SilentlyContinue innebär att om ett fel uppstår så sker det i det tysta utan att visa ett felmeddelande.
function Remove-SaveGame {
    $savePath = Get-SavePath
    if (Test-Path $savePath) {
        Remove-Item -Path $savePath -Force -ErrorAction SilentlyContinue
    }
}

#   Exporterar tre funktioner (Save-Game, Load-Game, Remove-SaveGame) så att de kan användas av andra moduler som importerar SaveSystem-modulen.
Export-ModuleMember -Function Save-Game, Load-Game, Remove-SaveGame