# GameEngine.psm1
# Hanterar spelflödet och kopplingar mellan moduler

$currentDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Import-Module (Join-Path $currentDir "RoomProvider.psm1") -Force
Import-Module (Join-Path $currentDir "TeoriProvider.psm1") -Force
Import-Module (Join-Path $currentDir "SaveSystem.psm1") -Force
Import-Module (Join-Path $currentDir "ConsoleUI.psm1") -Force

function Show-Teori {
    $teorier = Get-Teori

    Clear-Screen
    Write-Host "FÖRBEREDELSE INFÖR ESCAPE ROOM" -ForegroundColor Cyan
    Write-Host ""

    foreach ($teori in $teorier) {
        Write-Host $teori.Title -ForegroundColor Yellow
        Write-Host ""
        Write-Host $teori.Text
        Write-Host ""

        Write-Host "Viktigt att komma ihåg:" 

        foreach ($point in $teori.KeyPoints) {
            Write-Host "- $point"
        }

        Write-Host ""
        Write-Host "Tryck Enter för att fortsätta" -ForegroundColor Green
        Read-Host | Out-Null    
        Clear-Screen
    }
}

function Play-GameLoop ($SaveGame) {
    $gameRunning = $true
    $totalRooms = (Get-Rooms).Count

    while ($gameRunning) {
        if ([string]::IsNullOrEmpty($SaveGame.CurrentRoomId) -or $SaveGame.IsCompleted) {
            $SaveGame.IsCompleted = $true
            Show-GameOver -SaveGame $SaveGame -TotalRooms $totalRooms
            Remove-SaveGame
            $gameRunning = $false
            break
        }

        $room = Get-RoomById -RoomId $SaveGame.CurrentRoomId
        if ($null -eq $room) {
            Show-Message -Message "Kunde inte ladda rummet." -Color "Red"
            $gameRunning = $false
            break
        }

        Show-TeoriForRoom -RoomId $room.Id

        Show-Room -Room $room -SaveGame $SaveGame
        $choice = Get-PlayerChoice -MaxOptions $room.Options.Count

        if ($choice -eq "SPARA") {
            Save-Game -SaveGame $SaveGame
            Show-Message -Message "Spelet har sparats!" -Color "Green"
            $gameRunning = $false
            break
        }

        if ($choice -eq $room.CorrectOption) {
            if ($SaveGame.CompletedRooms -notcontains $room.Id) {
                $SaveGame.CompletedRooms += $room.Id
                $SaveGame.Score = [int]$SaveGame.Score + 1
            }
            Show-Feedback -IsCorrect $true -FeedbackText $room.SuccessText
        } else {
            Show-Feedback -IsCorrect $false -FeedbackText $room.FailureText
        }

        $SaveGame.CurrentRoomId = $room.NextRoomId
        Save-Game -SaveGame $SaveGame

        Show-Message -Message "Tryck på Enter för att fortsätta..." -Color "Yellow"
    }
}

# Huvudmeny-loop. Navigerar mellan meny och spel, själva spelandet sköts av Play-GameLoop.
function Start-Game {
    $running = $true

    while ($running) {
        # Alternativet för att fortsätta ett sparat spel ska bara visas om sparfilen finns och inte är avklarad
        $hasSave = $false
        try {
            $loadedSave = Load-Game
            if ($null -ne $loadedSave -and -not $loadedSave.IsCompleted) {
                $hasSave = $true
            }
        } catch {
            # Trasig sparfil ska inte krascha menyn, $hasSave förblir $false
        }

        $menuChoice = Show-MainMenu -HasSaveGame $hasSave

        switch ($menuChoice) {
            "1" {
                try {
                    # Försök ladda rummen i förväg för att fånga eventuella problem innan spelet startar
                    $rooms = Get-Rooms
                    if ($rooms.Count -eq 0) {
                        Show-Message -Message "Det finns inga rum i rooms.json." -Color "Red"
                        continue
                    }
                }
                catch {
                    # Om det är problem med rooms.json så kan vi inte starta spelet, visa ett felmeddelande och återgå till menyn
                    Show-Message -Message "Kan inte starta spel: $_" -Color "Red"
                    continue
                }

                $playerName = Get-PlayerName

                # Samma struktur som SaveSystem sparar/laddar
                $newSave = [PSCustomObject]@{
                    PlayerName     = $playerName
                    CurrentRoomId  = "room1"
                    CompletedRooms = @()
                    Score          = 0
                    IsCompleted    = $false
                }

                Play-GameLoop -SaveGame $newSave
            }
            "2" {
                try {
                    $save = Load-Game
                    if ($null -eq $save) {
                        Show-Message -Message "Hittade inget sparat spel." -Color "Red"
                    } else {
                        Play-GameLoop -SaveGame $save
                    }
                }
                catch {
                    Show-Message -Message "Fel vid laddning: $_" -Color "Red"
                }
            }
            "3" {
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
        Write-Host "Tryck Enter för att börja rummet" -NoNewline -ForegroundColor Green
        Read-Host
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

        Write-Host "Viktigt att komma ihåg:" -ForegroundColor Yellow

        foreach ($point in $teori.KeyPoints) {
            Write-Host "- $point"
        }

        Write-Host ""
        Write-Host "Tryck Enter för att börja rummet " -NoNewline -ForegroundColor Green
        Read-Host
    }
}

Export-ModuleMember -Function Start-Game

Export-ModuleMember -Function Start-Game
