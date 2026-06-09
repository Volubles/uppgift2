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

Hanterar det användaren ser och skriver i terminalen.

Anropas av:
- GameEngine.psm1

Ansvar:
- visa meny
- visa rum
- läsa användarens val
- visa feedback
