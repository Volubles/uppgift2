# uppgift2

Projektarbete 2 i Projektmetodik.

Vi bygger spår C: **Säkerhetsutbildning via CLI**.

Målet är ett enkelt terminalspel i PowerShell där användaren får gå igenom IT-säkerhetsscenarier och välja rätt åtgärd.

## Grundprincip

```text
JSON = innehåll
PowerShell = logik
```

Frågor och rum ligger i:

```text
data/rooms.json
```

PowerShell-filerna läser in datan och kör spelet.

## Körning

Starta spelet:

```powershell
.\main.ps1
```

Kör enkel test:

```powershell
.\tests\Test-MVP.ps1
```

## Viktiga filer

- [main.ps1](main.ps1) – startar spelet
- [rooms.json](data/rooms.json) – spelets rum och frågor
- [data/README.md](data/README.md) – förklarar `rooms.json`
- [src/modules](src/modules) – PowerShell-moduler
- [Test-MVP.ps1](tests/Test-MVP.ps1) – enkel testfil

## Löpande logg

- [Work log](docs/work-log.md) – kort logg över vad vi gjort, varför vi gjorde det och vad nästa steg är

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
