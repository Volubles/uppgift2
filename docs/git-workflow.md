# Git-workflow

Vi jobbar inte direkt i `main`.

`main` ska vara den stabila versionen som fungerar.

## Innan nytt arbete

```powershell
git switch main
git pull origin main
git status --short
```

Om allt ser rent ut skapar man en egen branch.

## Branchnamn

Använd enkla engelska namn:

```text
setup/foundation
feature/game-engine
feature/room-provider
feature/save-system
feature/console-ui
feature/rooms-json
docs/adkar-plan
fix/input-validation
fix/save-load
```

## Prefix

```text
setup/   = grund eller projektsetup
feature/ = ny funktion
docs/    = dokumentation
fix/     = buggfix
test/    = tester
```

## När du jobbar

1. Ta ett kort i GitHub Projects.
2. Assigna dig själv.
3. Flytta kortet till `In Progress`.
4. Skapa egen branch.
5. Gör ändringen.
6. Testa.
7. Commit och push.
8. Skapa Pull Request.
9. Merge först när ändringen är testad.

## Exempel

```powershell
git switch main
git pull origin main
git status --short
git switch -c feature/room-provider
```

När du är klar:

```powershell
git add .
git commit -m "Add room provider"
git push -u origin feature/room-provider
```

Sedan skapar du Pull Request på GitHub.
