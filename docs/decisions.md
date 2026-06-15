# Beslut

Den här filen används för beslut gruppen tar under projektet.

## Beslut 1 – JSON för rum

Vi använder JSON för spelets rum och frågor.

Motivering:
Rummen innehåller flera fält och svarsalternativ. JSON passar bättre än CSV.

## Beslut 2 – Modulstruktur

Vi delar upp koden i flera PowerShell-moduler.

Motivering:
Varje fil får ett tydligare ansvar och blir lättare att förstå.


## Beslut 3 – GitHub Gist för extern resultatloggning

Vi skickar spelarens slutresultat till en GitHub Gist via GitHub API när spelet är avklarat.

Alternativ som övervägdes:
Discord webhook (enkelt men kräver konto för att läsa loggen)
Google Sheets (bra visuellt men komplex autentisering)


Motivering:
Ur ett ITIL-perspektiv är valet motiverat av Continual Improvement:
loggen ger IT-avdelningen ett löpande, automatiskt underlag för att
identifiera var i organisationen kunskapsgap finns. Om ett specifikt
scenario återkommer som svagt område för många medarbetare är det en
signal om att utbildningsmaterialet eller den interna kommunikationen
kring just det hotet behöver förstärkas.

Loggen nås via en enkel länk utan att mottagaren behöver ett GitHub-konto,
vilket gör den tillgänglig för chefer och IT-ansvariga utan tekniska
förkunskaper. Det minskar tröskeln för att faktiskt använda datan som
beslutsunderlag, vilket är förutsättningen för att Continual Improvement
ska fungera i praktiken, inte bara på pappret.