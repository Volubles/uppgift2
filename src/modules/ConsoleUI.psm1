# ConsoleUI.psm1
# Hanterar all inmatning och utmatning i konsolen.
# Modulen innehåller ingen spellogik, ingen poänglogik och ingen sparlogik.


# Rensar terminalen innan en ny vy visas.
function Clear-Screen {
    try {
        Clear-Host
    }
    catch {
        Write-Host ""
    }
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


# Läser spelarens val. S kan användas för att spara och avsluta.
function Get-PlayerChoice {
    param(
        [int]$MaxOptions
    )

    while ($true) {
        $choice = Read-Host "Välj 1-$MaxOptions eller S för att spara"

        if ($choice -eq "S" -or $choice -eq "s") {
            return "SPARA"
        }

        $number = 0
        if ([int]::TryParse($choice, [ref]$number)) {
            if ($number -ge 1 -and $number -le $MaxOptions) {
                return $number
            }
        }

        Write-Host "Ogiltigt val."
    }
}


# Visar om spelarens svar var rätt eller fel.
function Show-Feedback {
    param(
        [bool]$IsCorrect,
        [string]$FeedbackText
    )

    if ($IsCorrect) {
        Write-Host ""
        Write-Host "Rätt!" -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Host "Fel." -ForegroundColor Red
    }

    Write-Host $FeedbackText
    Wait-ForEnter
}


# Visar slutskärmen när spelet är klart.
function Show-GameOver {
    param(
        $SaveGame,
        [int]$TotalRooms
    )

    Clear-Screen
    Show-Header

    Write-Host "Spelet är klart."
    Write-Host "Spelare: $($SaveGame.PlayerName)"
    Write-Host "Poäng: $($SaveGame.Score) av $TotalRooms"
    Write-Host ""

    Wait-ForEnter
}


# Visar ett enkelt meddelande.
function Show-Message {
    param(
        [string]$Message,
        [string]$Color = "White"
    )

    Write-Host $Message -ForegroundColor $Color
}


# Pausar tills användaren trycker Enter.
function Wait-ForEnter {
    Read-Host "Tryck på Enter för att fortsätta" | Out-Null
}


Export-ModuleMember -Function Clear-Screen, Show-Header, Show-MainMenu, Get-PlayerName, Show-Room, Get-PlayerChoice, Show-Feedback, Show-GameOver, Show-Message, Wait-ForEnter
