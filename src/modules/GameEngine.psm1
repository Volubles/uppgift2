# GameEngine.psm1
# Hanterar spelflödet och kopplingar mellan moduler

$currentDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Import-Module (Join-Path $currentDir "RoomProvider.psm1") -Force
Import-Module (Join-Path $currentDir "SaveSystem.psm1") -Force
Import-Module (Join-Path $currentDir "ConsoleUI.psm1") -Force