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

    if ($HasSaveGame) {
        Write-Host "2. Fortsätt sparat spel"
    }
    else {
        Write-Host "2. Fortsätt sparat spel (saknas)"
    }

    Write-Host "3. Avsluta"
    Write-Host ""

    while ($true) {
        $choice = Read-Host "Välj 1-3"

        if ($choice -eq "1") {
            return "1"
        }
        elseif ($choice -eq "2") {
            if ($HasSaveGame) {
                return "2"
            }

            Write-Host "Det finns inget sparat spel."
        }
        elseif ($choice -eq "3") {
            return "3"
        }
        else {
            Write-Host "Ogiltigt val."
        }
    }
}


# Läser spelarens namn och tillåter inte tom input.
function Get-PlayerName {
    while ($true) {
        $name = Read-Host "Ange ditt namn"

        if (-not [string]::IsNullOrWhiteSpace($name)) {
            return $name.Trim()
        }

        Write-Host "Namnet får inte vara tomt."
    }
}


# Visar aktuellt rum, spelarstatus och svarsalternativ.
function Show-Room {
    param(
        $Room,
        $SaveGame
    )

    Clear-Screen
    Show-Header

    Write-Host "Spelare: $($SaveGame.PlayerName)"
    Write-Host "Poäng: $($SaveGame.Score)"
    Write-Host "Rum: $($Room.Title)"
    Write-Host ""

    Write-Host $Room.Description
    Write-Host ""

    for ($i = 0; $i -lt $Room.Options.Count; $i++) {
        $optionNumber = $i + 1
        Write-Host "$optionNumber. $($Room.Options[$i])"
    }

    Write-Host ""
}
