# Modulkontrakt

Den här filen beskriver kort vad varje PowerShell-fil ansvarar för.

## main.ps1

Startar spelet och importerar moduler.

Anropar:
- GameEngine.psm1

Ska inte:
- innehålla alla rum
- innehålla all spellogik

## GameEngine.psm1

Styr spelets huvudflöde.

Anropar:
- RoomProvider.psm1
- SaveSystem.psm1
- ConsoleUI.psm1

Ansvar:
- starta nytt spel
- gå till rätt rum
- kontrollera svar
- uppdatera poäng/progress

## RoomProvider.psm1

Läser in rum från data/rooms.json och returnerar dem som PowerShell-objekt.

Anropas av:
- GameEngine.psm1

Ska inte:
- visa text i terminalen
- spara progress

## SaveSystem.psm1

Sparar och laddar spelarens progress.

Läser/skriver:
- data/savegame.json

Anropas av:
- GameEngine.psm1

## ConsoleUI.psm1

Hanterar all inmatning och utmatning i terminalen.

Anropas av:
- GameEngine.psm1

Ansvar:
- rensa terminalen
- visa spelets rubrik
- visa huvudmeny
- läsa spelarens namn
- visa aktuellt rum
- visa svarsalternativ
- läsa spelarens val
- visa feedback efter svar
- visa slutskärm
- visa enkla meddelanden
- pausa tills användaren trycker Enter

Ansvarar inte för:
- att läsa rooms.json
- att avgöra om svar är rätt eller fel
- att räkna poäng
- att spara eller ladda spel
- att välja nästa rum

Exporterade funktioner:
- Clear-Screen
- Show-Header
- Show-MainMenu
- Get-PlayerName
- Show-Room
- Get-PlayerChoice
- Show-Feedback
- Show-GameOver
- Show-Message
- Wait-ForEnter
