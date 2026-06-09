# GameEngine.psm1
# Hanterar spelflödet och kopplingar mellan moduler

$currentDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Import-Module (Join-Path $currentDir "RoomProvider.psm1") -Force
Import-Module (Join-Path $currentDir "SaveSystem.psm1") -Force
Import-Module (Join-Path $currentDir "ConsoleUI.psm1") -Force

function Play-GameLoop ($SaveGame) {
    $gameRunning = $true

    while ($gameRunning) {
        if ([string]::IsNullOrEmpty($SaveGame.CurrentRoomId)) {
            $gameRunning = $false
            break
        }

        $room = Get-RoomById -RoomId $SaveGame.CurrentRoomId
        Show-Room -Room $room -SaveGame $SaveGame
        $choice = Get-PlayerChoice -MaxOptions $room.Options.Count

        if ($choice -eq $room.CorrectOption) {
            Show-Feedback -IsCorrect $true -FeedbackText $room.SuccessText
        } else {
            Show-Feedback -IsCorrect $false -FeedbackText $room.FailureText
        }

        $SaveGame.CurrentRoomId = $room.NextRoomId
    }
}
