# Systemtopologi

Den här filen beskriver hur projektets delar hänger ihop.

## Grundflöde

1. `main.ps1` importerar `GameEngine.psm1` och startar programmet.
2. `GameEngine.psm1` styr huvudmenyn och spelets flöde.
3. `GameEngine.psm1` hämtar rum via `RoomProvider.psm1`.
4. `RoomProvider.psm1` läser rummens frågor och svar från `data/rooms.json`.
5. `GameEngine.psm1` hämtar tillhörande teori via `TeoriProvider.psm1`.
6. `TeoriProvider.psm1` läser teorin från `data/teorin.json`.
7. `ConsoleUI.psm1` visar menyer, teori, rum och feedback samt läser användarens val.
8. `GameEngine.psm1` kontrollerar svaret och uppdaterar poäng och framsteg.
9. `SaveSystem.psm1` sparar och laddar framsteg i `data/savegame.json`.
10. `TechnicalLogging.psm1` skriver tekniska händelser till en JSONL-fil i `logs/`.
11. När spelet är klart skickar `ResultLogger.psm1` resultatet till en GitHub Gist, om resultatloggningen är konfigurerad.

## Moduler och dataflöde

```text
main.ps1
    |
    v
GameEngine.psm1
    |-- RoomProvider.psm1 ------> data/rooms.json
    |-- TeoriProvider.psm1 -----> data/teorin.json
    |-- SaveSystem.psm1 --------> data/savegame.json
    |-- ConsoleUI.psm1 ---------> terminalen
    |-- TechnicalLogging.psm1 --> logs/game-YYYY-MM-DD.jsonl
    `-- ResultLogger.psm1 ------> GitHub Gist
```

## Resultatloggning

`ResultLogger.psm1` behöver en GitHub-token och ett Gist-ID för att kunna
skicka resultat. Värdena läses i följande ordning:

1. Miljövariablerna `GITHUB_TOKEN` och `GIST_ID`.
2. Den lokala filen `config.ps1`.

`config.ps1` skapas med hjälp av `config.template.ps1` och ska inte läggas
in i Git eftersom den innehåller känsliga uppgifter. Om konfigurationen
saknas fortsätter spelet att fungera, men resultatet skickas inte till Gist.

## Runtime-filer

Följande filer skapas när programmet körs och är inte en del av spelets
fasta innehåll:

- `data/savegame.json` innehåller ett pågående sparat spel.
- `logs/game-YYYY-MM-DD.jsonl` innehåller tekniska logghändelser.


