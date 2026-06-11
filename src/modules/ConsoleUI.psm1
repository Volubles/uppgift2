# ConsoleUI.psm1
# Hanterar all inmatning och utmatning i konsolen.

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

# Läser spelarens val och returnerar antingen ett nummer eller texten SPARA.
function Get-PlayerChoice {
    param(
        [int]$MaxOptions
    )

    while ($true) {
        $inputValue = Read-Host "Välj 1-$MaxOptions eller skriv SPARA"
        $cleanInput = $inputValue.Trim().ToUpper()

        if ($cleanInput -eq "SPARA" -or $cleanInput -eq "S") {
            return "SPARA"
        }

        $number = 0

        if ([int]::TryParse($cleanInput, [ref]$number)) {
            if ($number -ge 1 -and $number -le $MaxOptions) {
                return $number
            }
        }

        Write-Host "Ogiltigt val."
    }
}


# Visar om spelarens svar var rätt eller fel samt feedbacktexten från rummet.
function Show-Feedback {
    param(
        [bool]$IsCorrect,
        [string]$FeedbackText
    )

    Write-Host ""

    if ($IsCorrect) {
        Write-Host "RÄTT"
    }
    else {
        Write-Host "FEL"
    }

    Write-Host $FeedbackText
    Write-Host ""
}


# Visar slutskärmen när spelet är klart.
function Show-GameOver {
    param(
        $SaveGame,
        [int]$TotalRooms
    )

    Clear-Screen
    Show-Header

    Write-Host "Spelet är slut."
    Write-Host "Spelare: $($SaveGame.PlayerName)"
    Write-Host "Poäng: $($SaveGame.Score) av $TotalRooms"
    Write-Host ""

    Read-Host "Tryck Enter för att avsluta" | Out-Null
}


# Visar ett enkelt meddelande. Color-parametern finns kvar för kompatibilitet med GameEngine.
function Show-Message {
    param(
        [string]$Message,
        [string]$Color = "White"
    )

    Write-Host $Message
}


# Pausar spelet tills användaren trycker Enter.
function Wait-ForEnter {
    Read-Host "Tryck Enter för att fortsätta" | Out-Null
}

# Visar teori kopplad till aktuellt rum.
function Show-Teori {
    param(
        $Teori
    )

    Clear-Screen
    Show-Header

    Write-Host $Teori.Title
    Write-Host ""
    Write-Host $Teori.Text
    Write-Host ""

    if ($null -ne $Teori.KeyPoints) {
        Write-Host "Viktigt:"

        foreach ($point in $Teori.KeyPoints) {
            Write-Host "- $point"
        }

        Write-Host ""
    }
}


# Exporterar funktionerna så att GameEngine kan anropa dem efter import.
Export-ModuleMember -Function Clear-Screen, Show-Header, Show-MainMenu, Get-PlayerName, Show-Room, Get-PlayerChoice, Show-Feedback, Show-GameOver, Show-Message, Wait-ForEnter, Show-Teori
