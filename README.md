# uppgift2

Projektarbete 2 i Projektmetodik.

Vi bygger spår C: **Säkerhetsutbildning via CLI**.

Målet är ett enkelt terminalspel i PowerShell där användaren får läsa teori,
gå igenom IT-säkerhetsscenarier och välja rätt åtgärd.

## Grundprincip

```text
JSON = innehåll
PowerShell = logik
```

Frågor, rum och teori ligger i:

```text
data/rooms.json
data/teorin.json
```

PowerShell-filerna läser in datan och kör spelet.

## Krav

- Windows PowerShell 5.1 eller PowerShell 7
- Inga externa PowerShell-moduler behöver installeras

## Kom igång

Öppna PowerShell och gå till projektmappen:

```powershell
cd sökväg\till\uppgift2
```

Starta spelet:

```powershell
.\main.ps1
```

Spelet skapar automatiskt en sparfil i `data/savegame.json` när framsteg
sparas. Tekniska händelser skrivs till mappen `logs/`.

## Valfri resultatloggning

När ett spel är klart kan resultatet skickas till en GitHub Gist.
Spelet fungerar även om detta inte konfigureras.

Använd miljövariablerna `GITHUB_TOKEN` och `GIST_ID`, eller:

1. Kopiera `config.template.ps1` till `config.ps1`.
2. Fyll i din GitHub-token och ditt Gist-ID i `config.ps1`.
3. Starta spelet som vanligt.

`config.ps1` innehåller känsliga uppgifter och ska inte läggas in i Git.

## Tester

Kör testerna från projektroten:

```powershell
.\tests\Test-MVP.ps1
.\tests\Test-TechnicalLogging.ps1
```

`Test-ConsoleUI.ps1` är interaktivt och väntar på Enter under körningen:

```powershell
.\tests\Test-ConsoleUI.ps1
```

## Viktiga filer

- [main.ps1](main.ps1) - startar spelet
- [rooms.json](data/rooms.json) - spelets rum, frågor och svar
- [teorin.json](data/teorin.json) - teori som visas inför varje rum
- [data/README.md](data/README.md) - beskriver datafilerna
- [src/modules](src/modules) - PowerShell-moduler
- [tests](tests) - projektets tester
- [config.template.ps1](config.template.ps1) - mall för resultatloggning

## Löpande logg

- [Work log](docs/work-log.md) - kort logg över vad vi gjort, varför vi gjorde
  det och vad nästa steg är

## Dokumentation

- [Implementationsplan](docs/implementation-plan.md)
- [Systemtopologi](docs/system-topology.md)
- [Modulkontrakt](docs/module-contracts.md)
- [Git-arbetsflöde](docs/git-workflow.md)
- [Produktvision](docs/product-vision.md)
- [ADKAR-plan](docs/adkar-plan.md)
- [Daily standups](docs/daily-standups.md)
- [Sprint review](docs/sprint-review.md)
- [Sprint retrospective](docs/sprint-retrospective.md)
- [Beslut](docs/decisions.md)

## Arbetsflöde

Vi jobbar inte direkt i `main`.

```text
main = stabil version
egen branch = eget arbete
pull request = granskning innan merge
```

Se mer i [Git-workflow](docs/git-workflow.md).
