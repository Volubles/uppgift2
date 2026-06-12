# GameEngine.psm1
# Hanterar spelflödet och kopplingar mellan moduler.

$currentDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Import-Module (Join-Path $currentDir "RoomProvider.psm1") -Force
Import-Module (Join-Path $currentDir "TeoriProvider.psm1") -Force
Import-Module (Join-Path $currentDir "SaveSystem.psm1") -Force
Import-Module (Join-Path $currentDir "ConsoleUI.psm1") -Force
Import-Module (Join-Path $currentDir "LoggingSystem.psm1") -Force


# Skriver tekniska logghändelser utan att spelet kraschar om loggningen misslyckas.
function Write-GameLog {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Event,

        [string]$Message = "",

        [ValidateSet("INFO", "WARN", "ERROR")]
        [string]$Level = "INFO",

        [hashtable]$Data = @{}
    )

    try {
        Write-LogEvent -Event $Event -Message $Message -Level $Level -Data $Data | Out-Null
    }
    catch {
        # Loggning får aldrig stoppa spelet.
    }
}


function Show-Teori {
    $teorier = Get-Teori

    Clear-Screen
    Write-Host "=== FÖRBEREDELSE INFÖR ESCAPE ROOM ===" -ForegroundColor Cyan
    Write-Host ""

    foreach ($teori in $teorier) {
        Write-Host $teori.Title -ForegroundColor Yellow
        Write-Host ""
        Write-Host $teori.Text
        Write-Host ""

        Write-Host "Viktigt att komma ihåg:" -ForegroundColor Cyan

        foreach ($point in $teori.KeyPoints) {
            Write-Host "- $point"
        }

        Write-Host ""
        Read-Host "Tryck Enter för att fortsätta"
        Clear-Screen
    }
}


function Play-GameLoop ($SaveGame) {
    $gameRunning = $true
    $totalRooms = (Get-Rooms).Count

    # Loggar att själva spelloopen startar.
    Write-GameLog -Event "GameLoopStarted" -Message "Spelloopen startades." -Data @{
        PlayerName = $SaveGame.PlayerName
        CurrentRoomId = $SaveGame.CurrentRoomId
        Score = $SaveGame.Score
    }

    while ($gameRunning) {
        if ([string]::IsNullOrEmpty($SaveGame.CurrentRoomId) -or $SaveGame.IsCompleted) {
            $SaveGame.IsCompleted = $true

            # Loggar att spelet är färdigt.
            Write-GameLog -Event "GameCompleted" -Message "Spelet slutfördes." -Data @{
                PlayerName = $SaveGame.PlayerName
                FinalScore = $SaveGame.Score
                TotalRooms = $totalRooms
            }

            Show-GameOver -SaveGame $SaveGame -TotalRooms $totalRooms
            Remove-SaveGame
            $gameRunning = $false
            break
        }

        $room = Get-RoomById -RoomId $SaveGame.CurrentRoomId

        if ($null -eq $room) {
            # Loggar fel om rummet inte kan laddas.
            Write-GameLog -Event "RoomLoadFailed" -Level "ERROR" -Message "Kunde inte ladda aktuellt rum." -Data @{
                CurrentRoomId = $SaveGame.CurrentRoomId
            }

            Show-Message -Message "Kunde inte ladda rummet." -Color "Red"
            $gameRunning = $false
            break
        }

        # Loggar vilket rum som laddades.
        Write-GameLog -Event "RoomLoaded" -Message "Rum laddades." -Data @{
            RoomId = $room.Id
            RoomTitle = $room.Title
            Score = $SaveGame.Score
        }

        Show-TeoriForRoom -RoomId $room.Id

        Show-Room -Room $room -SaveGame $SaveGame
        $choice = Get-PlayerChoice -MaxOptions $room.Options.Count

        # Loggar spelarens val.
        Write-GameLog -Event "PlayerChoice" -Message "Spelaren gjorde ett val." -Data @{
            RoomId = $room.Id
            Choice = $choice
        }

        if ($choice -eq "SPARA") {
            Save-Game -SaveGame $SaveGame

            # Loggar att spelet sparades.
            Write-GameLog -Event "GameSaved" -Message "Spelet sparades av spelaren." -Data @{
                PlayerName = $SaveGame.PlayerName
                CurrentRoomId = $SaveGame.CurrentRoomId
                Score = $SaveGame.Score
            }

            Show-Message -Message "Spelet har sparats!" -Color "Green"
            $gameRunning = $false
            break
        }

        $isCorrect = ($choice -eq $room.CorrectOption)

        if ($isCorrect) {
            if ($SaveGame.CompletedRooms -notcontains $room.Id) {
                $SaveGame.CompletedRooms += $room.Id
                $SaveGame.Score = [int]$SaveGame.Score + 1
            }

            Show-Feedback -IsCorrect $true -FeedbackText $room.SuccessText
        }
        else {
            Show-Feedback -IsCorrect $false -FeedbackText $room.FailureText
        }

        # Loggar om svaret var rätt eller fel.
        Write-GameLog -Event "AnswerEvaluated" -Message "Spelarens svar rättades." -Data @{
            RoomId = $room.Id
            Choice = $choice
            CorrectOption = $room.CorrectOption
            IsCorrect = $isCorrect
            Score = $SaveGame.Score
        }

        $SaveGame.CurrentRoomId = $room.NextRoomId
        Save-Game -SaveGame $SaveGame

        # Loggar vilket rum spelet går vidare till.
        Write-GameLog -Event "RoomAdvanced" -Message "Spelet gick vidare till nästa rum." -Data @{
            NextRoomId = $SaveGame.CurrentRoomId
            Score = $SaveGame.Score
        }

        Show-Message -Message "Tryck på Enter för att fortsätta..." -Color "Yellow"
    }
}


# Huvudmeny-loop. Navigerar mellan meny och spel.
function Start-Game {
    $running = $true

    # Loggar att spelet startades.
    Write-GameLog -Event "GameStarted" -Message "Spelet startades."

    while ($running) {
        # Alternativet för att fortsätta ett sparat spel ska bara visas om sparfilen finns och inte är avklarad.
        $hasSave = $false

        try {
            $loadedSave = Load-Game

            if ($null -ne $loadedSave -and -not $loadedSave.IsCompleted) {
                $hasSave = $true
            }
        }
        catch {
            # Trasig sparfil ska inte krascha menyn.
        }

        $menuChoice = Show-MainMenu -HasSaveGame $hasSave

        switch ($menuChoice) {
            "1" {
                try {
                    # Försök ladda rummen innan spelet startar.
                    $rooms = Get-Rooms

                    if ($rooms.Count -eq 0) {
                        Show-Message -Message "Det finns inga rum i rooms.json." -Color "Red"
                        continue
                    }
                }
                catch {
                    Write-GameLog -Event "RoomFileLoadFailed" -Level "ERROR" -Message "Kan inte starta spel." -Data @{
                        Error = $_.Exception.Message
                    }

                    Show-Message -Message "Kan inte starta spel: $_" -Color "Red"
                    continue
                }

                $playerName = Get-PlayerName

                # Samma struktur som SaveSystem sparar/laddar.
                $newSave = [PSCustomObject]@{
                    PlayerName     = $playerName
                    CurrentRoomId  = "room1"
                    CompletedRooms = @()
                    Score          = 0
                    IsCompleted    = $false
                }

                Write-GameLog -Event "NewGameStarted" -Message "Nytt spel startades." -Data @{
                    PlayerName = $newSave.PlayerName
                    CurrentRoomId = $newSave.CurrentRoomId
                }

                Play-GameLoop -SaveGame $newSave
            }

            "2" {
                try {
                    $save = Load-Game

                    if ($null -eq $save) {
                        Show-Message -Message "Hittade inget sparat spel." -Color "Red"
                    }
                    else {
                        Write-GameLog -Event "SaveGameLoaded" -Message "Sparat spel laddades." -Data @{
                            PlayerName = $save.PlayerName
                            CurrentRoomId = $save.CurrentRoomId
                            Score = $save.Score
                        }

                        Play-GameLoop -SaveGame $save
                    }
                }
                catch {
                    Write-GameLog -Event "SaveGameLoadFailed" -Level "ERROR" -Message "Fel vid laddning av sparat spel." -Data @{
                        Error = $_.Exception.Message
                    }

                    Show-Message -Message "Fel vid laddning: $_" -Color "Red"
                }
            }

            "3" {
                Write-GameLog -Event "GameExitedFromMenu" -Message "Spelaren avslutade från huvudmenyn."

                Clear-Screen
                Write-Host "Tack för att du spelade! Hejdå!" -ForegroundColor Green
                $running = $false
            }
        }
    }
}


function Show-TeoriForRoom {
    param (
        [string]$RoomId
    )

    $teorier = Get-TeoriByRoomId -RoomId $RoomId

    if ($null -eq $teorier -or $teorier.Count -eq 0) {
        Clear-Screen
        Write-Host "Ingen teori hittades för rum: $RoomId" -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Tryck Enter för att börja rummet"
        return
    }

    foreach ($teori in $teorier) {
        Clear-Screen
        Write-Host "TEORI INFÖR RUMMET" -ForegroundColor Cyan
        Write-Host ""

        Write-Host $teori.Title -ForegroundColor Yellow
        Write-Host ""
        Write-Host $teori.Text
        Write-Host ""

        Write-Host "Viktigt att komma ihåg:" -ForegroundColor Cyan

        foreach ($point in $teori.KeyPoints) {
            Write-Host "- $point"
        }

        Write-Host ""
        Read-Host "Tryck Enter för att börja rummet"
    }
}


Export-ModuleMember -Function Start-Game