## Implementationsplan

- `main.ps1` startar programmet.
- `GameEngine.psm1` tar emot starten och styr flödet.
- `RoomProvider.psm1` ansvarar senare för att läsa rum från `data/rooms.json`.
- `SaveSystem.psm1` ansvarar för att spara och ladda framsteg.
- `ConsoleUI.psm1` ansvarar för menyer, text och input från användaren.

Första målet kan alltså se ut så här:

1. `main.ps1` startar spelet.
2. `GameEngine.psm1` styr spelets flöde.
3. `RoomProvider.psm1` läser in rum från `data/rooms.json`.
4. Rummen returneras som PowerShell-objekt till `GameEngine.psm1`.
5. `SaveSystem.psm1` sparar och laddar spelarens progress.
6. `ConsoleUI.psm1` visar text i terminalen och läser användarens val.