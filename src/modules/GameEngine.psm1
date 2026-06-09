# GameEngine.psm1
# Hanterar spelflödet och kopplingar mellan moduler

$currentDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Import-Module (Join-Path $currentDir "RoomProvider.psm1") -Force
Import-Module (Join-Path $currentDir "SaveSystem.psm1") -Force
Import-Module (Join-Path $currentDir "ConsoleUI.psm1") -Force

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
