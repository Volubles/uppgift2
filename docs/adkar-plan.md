# ADKAR-plan

Den här filen används för förändringsledningen i projektet.

## Awareness

Användaren ska förstå varför säkerhetsutbildningen behövs.

Hur vi löser det:
Introduktionsrutan i main.ps1 sätter kontexten direkt vid start:
"Vi på IT vill påminna om att våra tekniska system bara är hälften av
företagets skydd, den andra hälften är du." Medarbetaren förstår redan
innan första frågan att deltagandet är meningsfullt och kopplat till
verksamhetens säkerhet.

## Desire

Spelet ska vara kortare och mer engagerande än vanlig passiv utbildning.

Hur vi löser det:
Scenariobaserat lärande. Spelaren fattar aktiva beslut i realistiska
situationer snarare än att passivt läsa en policy. Varje scenario är
kort och avslutas med direkt feedback.

## Knowledge

Spelet lär ut vad användaren bör göra i vanliga säkerhetssituationer.

Hur vi löser det:
Varje rum föregås av en teorisektion (teorin.json) som förklarar
bakgrunden till hotet. Efter varje svar visas SuccessText eller
FailureText som förklarar varför svaret var rätt eller fel, inte
bara om det var rätt eller fel.

## Ability

Användaren får öva genom att själv välja åtgärd i scenarierna.

Hur vi löser det:
Spelaren möter tre konkreta scenarietyper: phishing, USB-säkerhet och
lösenordshantering. Att aktivt välja rätt åtgärd i ett scenario tränar 
beslutsfattandet bättre än att läsa om det i en policy.

## Reinforcement
 
Spelet ger feedback efter varje svar och visar resultat i slutet.
Resultatloggen möjliggör uppföljning och kontinuerlig förbättring.
 
### Individuell feedback
 
Slutskärmen visar spelarens poäng och vilka områden hen svarade fel på.
Det ger en omedelbar signal om var mer inläsning behövs.
 
### Organisatorisk uppföljning via Gist-loggen
 
Varje genomspelning skickas automatiskt till en delad GitHub Gist med:
- Spelarens namn och datum
- Resultat (antal rätt av totalt)
- Godkänd/Ej godkänd
- Exakt vilka rum spelaren svarade fel på
Det ger IT-avdelningen eller chefen ett löpande underlag för att:
 
1. **Bekräfta genomförande** — vem har spelat och när?
2. **Identifiera mönster** — om många fastnar på samma rum pekar det
   på ett organisationsövergripande kunskapsgap, inte ett individuellt.
3. **Rikta åtgärder** — utbildningsinsatser kan fokuseras på de områden
   där data visar störst behov, istället för att alla genomgår allt.
4. **Mäta förbättring** — en medarbetare som gjort om spelet efter
   riktad utbildning syns som en ny rad i loggen. Jämförelsen mellan
   första och andra genomgången visar konkret om kunskapen förbättrats.
### Koppling till Continual Improvement (ITIL)
 
Loggdata är ingångsvärdet för ett kontinuerligt förbättringsflöde:
 
```
Spelare genomför utbildning
        │
        ▼
Resultat loggas i Gist (automatiskt)
        │
        ▼
IT/chef identifierar svaga områden i organisationen
        │
        ▼
Åtgärd: riktad utbildning, uppdaterade rum i rooms.json,
         ny teorisektion i teorin.json
        │
        ▼
Medarbetare gör om spelet → ny loggpost → mätbar förbättring
```
 
Eftersom innehållet (rum och teori) är separerat från koden i JSON-filer
kan materialet uppdateras utan att röra en enda rad PowerShell.
Det gör att IT kan uppdatera utbildningsmaterialet utan att behöva röra koden

## Motstånd

Om någon vägrar spela ska man först ta reda på varför:
- tidsbrist
- låg motivation
- teknisk osäkerhet
- förstår inte syftet

Åtgärd:
- förklara syftet
- erbjuda stöd
- erbjuda annan tidpunkt
- lyfta fortsatt vägran till chef enligt organisationens rutiner
