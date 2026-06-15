# Modulkontrakt

Den här filen beskriver vad varje PowerShell-fil ansvarar för och vilka
funktioner andra delar av programmet får använda.

## main.ps1

Startar spelet och importerar moduler.

Anropar:

- `Start-Game` från `GameEngine.psm1`

Ska inte:

- innehålla rum eller teori
- innehålla spellogik

## GameEngine.psm1

Styr spelets huvudflöde.

Ansvar:

- starta nytt spel
- fortsätta sparat spel
- visa teori och rätt rum
- kontrollera svar
- uppdatera poäng och framsteg
- samordna övriga moduler

Exporterade funktioner:

### `Start-Game`

Startar huvudmenyn och håller programmet igång tills användaren avslutar.

- Parametrar: inga
- Returvärde: inget
- Anropar: `RoomProvider`, `TeoriProvider`, `SaveSystem`, `ConsoleUI`,
  `TechnicalLogging` och `ResultLogger`

Ska inte:

- läsa eller skriva JSON-filer direkt
- hantera terminalinmatning direkt

## RoomProvider.psm1

Läser in rum från data/rooms.json och returnerar dem som PowerShell-objekt.

Exporterade funktioner:

### `Get-Rooms`

- Parametrar: inga
- Returvärde: en lista med samtliga rum
- Fel: kastar fel om `data/rooms.json` saknas eller innehåller ogiltig JSON

### `Get-RoomById`

- Parameter: `RoomId` – rummets unika ID
- Returvärde: rummet som matchar ID:t, annars `$null`

Ska inte:

- visa text i terminalen
- spara framsteg

## TeoriProvider.psm1

Läser in utbildningstexter från `data/teorin.json`.

Exporterade funktioner:

### `Get-Teori`

- Parametrar: inga
- Returvärde: en lista med samtliga teoridelar
- Fel: kastar fel om `data/teorin.json` saknas eller innehåller ogiltig JSON

### `Get-TeoriByRoomId`

- Parameter: `RoomId` – ID för rummet som teorin tillhör
- Returvärde: teoridelarna som är kopplade till rummet

Ska inte:

- visa teorin i terminalen
- ändra innehållet i teorifilen

## SaveSystem.psm1

Sparar och laddar spelarens progress.

Läser/skriver:

- `data/savegame.json`

Exporterade funktioner:

### `Save-Game`

- Parameter: `SaveGame` – objektet som ska sparas
- Returvärde: inget
- Fel: kastar fel om sparfilen inte kan skrivas

### `Load-Game`

- Parametrar: inga
- Returvärde: sparat spel, eller `$null` om sparfilen saknas
- Fel: kastar fel om sparfilen är ogiltig eller saknar obligatoriska fält

### `Remove-SaveGame`

- Parametrar: inga
- Returvärde: inget
- Effekt: tar bort sparfilen om den finns

## ConsoleUI.psm1

Hanterar all inmatning och utmatning i terminalen.

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

Exporterade funktioner:

- `Clear-Screen`
- `Show-Header`
- `Show-MainMenu -HasSaveGame <bool>` – returnerar menyvalet
- `Get-PlayerName` – returnerar ett namn som inte är tomt
- `Show-Room -Room <objekt> -SaveGame <objekt>`
- `Get-PlayerChoice -MaxOptions <int>` – returnerar ett alternativnummer eller
  strängen `SPARA`
- `Show-Feedback -IsCorrect <bool> -FeedbackText <string>`
- `Show-GameOver -SaveGame <objekt> -TotalRooms <int>`
- `Show-Message -Message <string> [-Color <string>]`
- `Wait-ForEnter`

Ska inte:

- kontrollera om svar är rätt
- ändra poäng eller sparat spel

## TechnicalLogging.psm1

Skriver tekniska händelser till en JSONL-logg i `logs/`.

Exporterade funktioner:

### `Get-LogFilePath`

- Parametrar: inga
- Returvärde: sökvägen till dagens loggfil, eller `$null` vid fel

### `Write-LogEvent`

- Obligatorisk parameter: `Event`
- Valfria parametrar: `Message`, `Level` och `Data`
- Returvärde: `$true` om händelsen skrevs, annars `$false`
- Tillåtna nivåer: `INFO`, `WARN` och `ERROR`

Loggningsfel ska inte stoppa spelet.

## ResultLogger.psm1

Skickar slutresultatet till en GitHub Gist om resultatloggning är
konfigurerad.

Exporterade funktioner:

### `Initialize-ResultLogger`

- Parametrar: inga
- Returvärde: en hashtabell med GitHub-token och Gist-ID
- Fel: kastar fel om nödvändig konfiguration saknas

### `Write-ResultToGist`

- Parametrar: `PlayerName`, `Score`, `Total`, `WeakAreas` och `Config`
- Returvärde: `$true` om resultatet skickades, annars `$false`

Resultatloggning är valfri. Fel vid kontakt med GitHub ska inte stoppa spelet.
