# Product Owner-plan

Det här dokumentet beskriver produktens verksamhetsvärde, mätbara mål,
prioriteringar och vad Product Owner ska kontrollera före slutligt
godkännande.

## Verksamhetsvärde

Security Escape Room ska hjälpa medarbetare att känna igen och hantera vanliga
IT-säkerhetsrisker innan de leder till incidenter.

Produkten skapar värde genom att:

- ge medarbetare praktisk träning i phishing, okända USB-enheter och lösenord
- identifiera områden där användare behöver mer utbildning
- ge organisationen underlag för riktade utbildningsinsatser
- på sikt minska undvikbara säkerhetsincidenter och belastningen på Service Desk

## Mätbara produktmål

Följande mål används för att bedöma om produkten skapar värde:

| Användarna genomför utbildningen | Andel startade spel som slutförs | Minst 90 % |
| Användarna förstår innehållet | Andel användare med full poäng | Minst 80 % |
| Svaga områden förbättras | Jämför resultat före och efter riktad utbildning | Minst 20 % förbättring |
| Service Desk-belastningen minskar | Jämför antal relaterade incidenter före och efter lansering | Minst 20 % minskning |

Målvärdena är föreslagna startvärden. Product Owner ansvarar för att justera
dem när organisationen har samlat in ett första jämförelseunderlag.

## Prioritering

Product Owner prioriterar förbättringar utifrån risk, resultatdata och
verksamhetsnytta.

Prioriteringsordning:

1. Områden där många användare svarar fel och ett misstag kan orsaka stor
   skada, exempelvis phishing.
2. Problem som leder till många ärenden hos Service Desk.
3. Fel som hindrar användare från att slutföra utbildningen.
4. Förbättringar av användarupplevelsen.
5. Nya scenarier och övriga funktioner.

Resultatloggen visar poäng och svaga områden. Product Owner använder denna
information tillsammans med statistik från Service Desk för att välja nästa
förbättring.

## Acceptanskriterier

Acceptanskriterierna har jämförts med den implementation, de tester och den
dokumentation som gruppen har tagit fram.

| Acceptanskriterium | Status | Underlag |
| Spelet kan startas via `main.ps1`. | Uppfyllt | `main.ps1` importerar spelmotorn och anropar `Start-Game`. `Test-MVP.ps1` verifierar att spelmotorn kan laddas. |
| Användaren kan läsa teori och genomföra samtliga säkerhetsscenarier. | Uppfyllt | `TeoriProvider.psm1`, `teorin.json` och spelloopen visar teori och samtliga rum. Funktionen har demonstrerats av gruppen. |
| Spelet ger tydlig feedback efter varje svar. | Uppfyllt | `Show-Feedback` visar om svaret är rätt eller fel tillsammans med rummets feedbacktext. |
| Poäng och svaga områden registreras korrekt. | Uppfyllt | Spelmotorn ökar poängen vid rätt svar och lägger rummets titel i `WeakAreas` vid fel svar. |
| Ett pågående spel kan sparas och fortsättas. | Uppfyllt | `SaveSystem.psm1` innehåller funktioner för att spara och ladda. Huvudmenyn visar alternativet att fortsätta när en sparfil finns. |
| Fel i datafiler eller resultatloggning kraschar inte hela spelet. | Uppfyllt | Fel fångas med `try/catch`. Fel i rum eller sparfil visas för användaren, och fel i resultatloggningen låter spelet fortsätta. |
| Tekniska händelser loggas för felsökning. | Uppfyllt | `TechnicalLogging.psm1` skriver JSONL-loggar. `Test-TechnicalLogging.ps1` passerar. |
| Resultat kan skickas till en GitHub Gist när funktionen är konfigurerad. | Uppfyllt | `ResultLogger.psm1` skickar resultat via GitHub API. Integrationen är dokumenterad som demonstrerad i sprint review och work log. |
| Spelet fungerar även när Gist-konfiguration saknas. | Uppfyllt | Spelmotorn fångar konfigurationsfelet och fortsätter utan resultatloggning. |
| Projektets tester passerar. | Uppfyllt | `Test-MVP.ps1` och `Test-TechnicalLogging.ps1` har körts utan fel. ConsoleUI-funktionerna kontrolleras i `Test-ConsoleUI.ps1` och har demonstrerats av gruppen. |
| Dokumentationen beskriver körning, arkitektur och modulernas ansvar. | Uppfyllt | `README.md`, `system-topology.md` och `module-contracts.md` beskriver dessa delar. |

Samtliga acceptanskriterier bedöms som uppfyllda utifrån genomförda tester,
demonstrationer, kodgranskning och projektdokumentation.

## Definition of Done

En User Story eller funktion är klar när:

- acceptanskriterierna för arbetet är uppfyllda
- ändringen har testats
- relevanta fel hanteras
- relevant dokumentation har uppdaterats
- arbetet har granskats genom Pull Request
- Product Owner har accepterat resultatet, eller dokumenterat vad som återstår

## Product Owners ansvar före redovisning

Product Owner ska:

1. Kontrollera att produktens verksamhetsvärde kan förklaras under
   redovisningen.
2. Granska produkten mot acceptanskriterierna ovan.
3. Kontrollera att prioriteringen bygger på risk och verksamhetsnytta.
4. Säkerställa att återstående arbete finns som User Stories eller Issues i
   GitHub Projects.
5. Dokumentera ett slutligt beslut i avsnittet nedan.

## Slutligt Product Owner-beslut

Samtliga acceptanskriterier är uppfyllda. Produkten rekommenderas därför för
godkännande. Product Owner bekräftar beslutet genom att fylla i namn och datum.

- Datum: 2026-06-16
- Product Owner: Benjamin Kullman
- Beslut: Rekommenderas för godkännande
- Godkända acceptanskriterier: Samtliga
- Kvarstående arbete: Inget som hindrar godkännande
- Motivering: Produkten uppfyller definierade acceptanskriterier och
  grundläggande tekniska krav.
