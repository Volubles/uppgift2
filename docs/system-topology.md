# Systemtopologi

Den här filen beskriver hur projektets delar hänger ihop.

## Grundflöde

Enkelt systemflöde

1. main.ps1 startar programmet.
2. main.ps1 anropar GameEngine.psm1.
3. GameEngine.psm1 styr spelets flöde.
4. GameEngine.psm1 hämtar rum via RoomProvider.psm1.
5. RoomProvider.psm1 läser data/rooms.json.
6. GameEngine.psm1 skickar rummet vidare till ConsoleUI.psm1.
7. ConsoleUI.psm1 visar text och läser användarens val.
8. GameEngine.psm1 kontrollerar svaret och uppdaterar progress.
9. GameEngine.psm1 använder SaveSystem.psm1 för att spara eller ladda.
10. SaveSystem.psm1 skriver/läser data/savegame.json.


