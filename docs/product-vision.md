# Product Vision

Vi bygger ett enkelt terminalbaserat säkerhetsspel i PowerShell.

Spelet ska lära användaren grundläggande IT-säkerhet genom korta scenarier där användaren får välja rätt åtgärd.

Målet är inte att bygga ett stort spel.

Målet är att visa:
- agilt arbetssätt
- PowerShell-scripting
- modulstruktur
- JSON som datakälla
- enkel felhantering
- säkerhetsutbildning med praktiska val

# Att arbeta mot tydliga mål:

 Få ihop en minimal version av spelet för att se till att alla moduler svarar korrekt när man kör .\main.ps1 för att sedan diskutera vidare funktioner. På det sättet kommer vi alltid att ha en fungerande version i bakgrunden och kan vidareutveckla beroende på tid och ideér.


## Att arbeta mot tydliga mål
 
Få ihop en minimal version av spelet för att se till att alla moduler
svarar korrekt när man kör `.\main.ps1`, för att sedan diskutera vidare
funktioner. På det sättet kommer vi alltid att ha en fungerande version
i bakgrunden och kan vidareutveckla beroende på tid och idéer.
 
---
 
## Värde och ITIL-koppling
 
### Vilket värde skapar spelet?
 
Spelet adresserar det faktum att mänskliga misstag är den vanligaste
orsaken till säkerhetsincidenter, inte tekniska brister. Introduktions-texten
formulerar det direkt för spelaren:
 
> "Vi på IT vill påminna om att våra tekniska system bara är hälften av
> företagets skydd, den andra hälften är du."
 
Genom att träna på realistiska scenarier (phishing, USB-säkerhet,
lösenordshantering) bygger medarbetaren förmågan att fatta rätt beslut
i situationer som annars leder till incidenter.
 
### Hur mäter vi att det skapar värde?
 
Varje genomspelning loggas automatiskt till en delad GitHub Gist med
spelarens namn, resultat, datum och exakt vilka områden hen svarade
fel på. Det ger ett konkret, löpande underlag utan manuell insamling.
 
Värdet mäts på två nivåer:
 
**Individuellt:** Har medarbetaren genomfört utbildningen? Klarade hen
alla moment, eller finns det specifika områden att repetera?
 
**Organisatoriskt:** Finns det mönster i loggen? Om en majoritet av
medarbetarna svarar fel på samma scenario är det ett tecken på ett
organisationsövergripande kunskapsgap, inte ett individuellt problem.
 
### Continual Improvement
 
Loggdata är ingångsvärdet för ett kontinuerligt förbättringsflöde.
IT-avdelningen eller chefen kan läsa loggen via en enkel länk
och identifiera vilka områden som behöver förstärkas.
 
Eftersom spelets innehåll är separerat från koden i JSON-filer
(`rooms.json`, `teorin.json`) kan nya scenarier, uppdaterad teori
eller justerade frågor läggas till utan att röra ett enda kodrader.
Det innebär att IT kan agera på loggdata direkt:
 
1. Loggen visar att många fastnar på phishing-rummet
2. IT uppdaterar `teorin.json` med ett mer utförligt teoriavsnitt
3. Eller lägger till ett nytt rum i `rooms.json` med ett fördjupande scenario
4. Medarbetare som behöver repetition gör om spelet
5. Ny loggpost visar om kunskapen förbättrats

### Koppling till Service Desk
 
En medarbetare som aktivt övat på att känna igen ett phishing-försök
är mer sannolikt att:
- Inte klicka på en skadlig länk
- Rapportera det misstänkta mejlet via rätt kanal
- Hantera en okänd USB-enhet korrekt
Dessa beteendeförändringar minskar direkt antalet incidenter som annars
hade landat hos Service Desk. Färre nätfiske-incidenter, färre
lösenordsåterställningar på grund av komprometterade konton, och färre
ärenden kopplade till skadlig kod från externa enheter innebär lägre
belastning och mer tid för Service Desk att hantera komplexa ärenden.
 
Det är inte möjligt att mäta den exakta minskningen utan en kontrollgrupp,
men loggdata ger en indirekt indikator: om andelen godkända genomspelningar
ökar över tid, och om medarbetare som gjort om spelet efter riktad
utbildning presterar bättre, är det ett rimligt tecken på att
säkerhetsmedvetenheten faktiskt förbättrats i organisationen.