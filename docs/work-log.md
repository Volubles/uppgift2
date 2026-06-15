# Work log

Den här filen används för kort löpande dokumentation under projektet.

Här skriver vi:

- vad som har gjorts
- varför det gjordes
- vem som skrev anteckningen
- vad nästa steg är

Den här filen är inte samma sak som `decisions.md`.

`work-log.md` = löpande anteckningar  
`decisions.md` = beslut gruppen faktiskt har tagit

## 2026-06-09 – Grundstruktur för projektet

**Skrivet av:** Joakim

Jag började med att sätta upp en struktur för projektet.

Syftet var inte att bygga hela spelet direkt, utan att skapa en tydlig bas med instruktioner till att börja med. Jag ville förstå hur vi på bästa sätt kan kommunicera, dokumentera, starta och underhålla projektet framåt.

Jag har försökt att ge alla moduler och filer ett tydligt syfte som gruppen sedan kan bygga vidare på. Jag valde att göra så här för att jag inte riktigt visste hur eller vad jag skulle börja med. Nu, några timmar senare, har jag en bättre övergripande blick och hoppas att gruppen gemensamt finner dokumentationen hjälpsam.

Jag passade också på att snygga till dokumentationen så att den blir lättare att läsa i GitHub. Jag lärde mig hur Markdown-länkar fungerar, till exempel att man kan länka direkt till andra filer i repot med `[Text](sökväg/till/fil.md)`. På så sätt kan root `README.md` fungera mer som en karta som pekar vidare till rätt dokument.

Jag använde även kodblock där det passar, till exempel för kommandon och enkla flöden. Ett kodblock gör att texten visas tydligare och inte blandas ihop med vanlig brödtext.

Det jag försöker få till är alltså inte bara “snygg dokumentation” (även om det är sjukt tillfredställande), utan dokumentation som hjälper gruppen att förstå projektets struktur snabbt utan att behöva leta runt i alla filer.



## 2026-06-09 – rooms.json samt RoomProvider.psm1
**Skrivet av:** Alexander (dev)

Jag har scriptat två funktioner i RoomProvider.psm1. Den ena, Get-Rooms som hämtar rummen från rooms.json (som jag även har skapat), och den andra funktionen, Get-RoomByID, som spelmotorn sen kommer till att använda för att skicka vidare en spelare till nästa scenario i escape-roomet. 


## 2026-06-09 - SaveSystem.psm1 samt savegame.json
**Skrivet av:** Martin (dev)

Skapade modulen som gör det möjligt för spelaren att spara och ladda spelsessioner. Vid sparandet av en session skapas savegame.json och läggs i mappen 'data'.
Lade till en funktion i slutet som rensar sparfilen så att man inte kan ladda och "fortsätta" på en avklarad session.

Vill man testa modulen SaveSystem.psm1 av någon annan del av projektet så kan se till att stå i projektmappen i terminalen och kopiera in följande (modifiera efter eget tycke och smak):

```powershell
Import-Module .\src\modules\SaveSystem.psm1 -Force

Remove-SaveGame                    # rensa ev. gammal sparfil först

# Påhittad data för som matas in i savegame.json
$test = [PSCustomObject]@{
    PlayerName     = "Astrid"
    CurrentRoomId  = "room3"
    CompletedRooms = @("room1", "room2")
    Score          = 2
    IsCompleted    = $false
}

Save-Game -SaveGame $test          # spara den nya datan
$laddat = Load-Game                # ladda tillbaka
$laddat                            # ska visa Astrid, room3, Score 2
```

## 2026-06-10 – ConsoleUI och första modulkontrakt

**Skrivet av:** Joakim

Idag arbetade jag med `ConsoleUI.psm1`, alltså modulen som ansvarar för det användaren ser i terminalen och det användaren skriver in.

Målet var att göra modulen så enkel som möjligt men ändå fungerande. Därför tog jag bort onödig grafik och färger tills vidare, så att vi först kan fokusera på att spelet fungerar korrekt. Tanken är att vi kan förbättra utseendet senare när hela flödet fungerar.

Jag såg också tydligare hur viktigt det är att modulerna har ett gemensamt kontrakt. `GameEngine.psm1` behöver kunna anropa funktioner i `ConsoleUI.psm1`, och därför måste funktionsnamn och parametrar stämma exakt. Annars får man fel även om själva idén i koden är rätt.

I `ConsoleUI.psm1` finns nu funktioner för att visa rubrik, huvudmeny, spelarens namn, aktuellt rum, spelarens val, feedback, slutskärm, meddelanden och paus. Modulen innehåller inte spellogik, poänglogik eller sparlogik. Den ska bara hantera inmatning och utmatning i konsolen.

Jag testade modulen genom att importera den i PowerShell och kontrollera att alla funktioner exporteras korrekt. Importtestet visade att funktionerna finns och att modulen kan laddas utan syntaxfel.

Jag skapade även en egen branch för arbetet, gjorde en commit och pushade branchen till GitHub. Nästa steg är att någon i gruppen granskar Pull Requesten innan den mergas till `main`.


## 2026-06-11 – Färdigställande av GameEngine

**Skrivet av:** Martin

Färdigställde GameEngine med funktionen Start-Game så att vi till slut kan få spelet att starta.
Modulen är inte helt komplett än men i dagsläget har den de två stora vitala funktionerna som krävs för körning.

## 2026-06-11 – Komplettering av ConsoleUI och sparfilshantering

**Skrivet av:** Joakim

Jag arbetade vidare med kopplingen mellan `GameEngine.psm1` och `ConsoleUI.psm1`. Spelet gick nu att starta och första rummet visades korrekt, men det kraschade när spelaren skulle göra sitt val. Felet berodde på att `GameEngine` försökte anropa `Get-PlayerChoice`, men den funktionen fanns inte tillgänglig i `ConsoleUI.psm1`.

Jag kompletterade därför `ConsoleUI.psm1` med de funktioner som behövdes för att spelet skulle kunna fortsätta efter att ett rum har visats. Det handlar bland annat om att läsa spelarens val, visa feedback efter svar, pausa spelet, visa slutskärmen och visa enkla meddelanden. Efter ändringen kunde `GameEngine` och `ConsoleUI` arbeta tillsammans på ett bättre sätt.

Jag tog också bort `data/savegame.json` från repot eftersom det är en sparfil som skapas när spelet körs. Den typen av runtime-fil ska inte ligga sparad i GitHub som en del av projektkoden. För att undvika att filen råkar läggas till igen lade jag även till `data/savegame.json` i `.gitignore`.

Jag testade ändringen genom att importera `ConsoleUI.psm1` i PowerShell och kontrollera att de nya funktionerna gick att hitta med `Get-Command`.

## 2026-06-11 – MVP & Teorimodul klar.

**Skrivet av:** Joakim

MVP läge fryst och teorimodul implementerad för att utbilda innan spelare går vidare till frågeställningen.

## 2026-06-12 – Loggning av resultat och uppladdning till Github Gist klar.

**Skrivet av:** Martin

Skapade ResultLogger.psm1 i syfte att logga resultatet från avklarade spelsessioner som sedan ska skickas till Github Gist.
Tanken med detta är att behörig personal på ett enkelt sätt ska kunna se de anställdas resultat från spelet och därmed och vilka som är helt godkända och vilka som eventuellt är i behov av utbildning inom IT-säkerhet.
Loggen ska kunna visa vilka områden användaren hade svårt för och därmed kan man nicha vidareutbildningen om så önskas.

Skapade config.template.ps1 som beskriver vad som behöver göras för varje användare så att publiceringen till Gisten fungerar.
Lade till config.ps1 i .gitignore så att viktig data ej hamnar publikt på internet.

**Uppdatering:**

ResultLogger är nu sammankopplad med GameEngine och nu skickas resultatet av ett avklarat spel till Gisten.
Detta förutsätter att config.ps1 är konfigurerat med GistId och GithubToken.

## 2026-06-12 – Färgsättning av text (förbättra upplevelsen för användaren).

**Skrivet av:** Alexander

Terminalgränssnittet har snyggats till och uppdaterats med dynamisk färgsättning på texterna. Detta har gjorts för att förbättra användarupplevelsen och göra informationen betydligt mer lättläst, tydlig och överskådlig för användaren under spelets gång.

## 2026-06-12 – Information till spelaren innan spelets start

**Skrivet av:** Martin

Hårdkodade in en informativ text innan spelaren når spelets meny för att informera om syftet och betydelsen av spelet.
Valde att göra på detta viset då koden inte var speciellt lång och för att slippa skapa nya filer eller behöva ändra i multipla filer.


## 2026-06-15 – Loggning av resultat och uppladdning till Github Gist klar.

**Skrivet av:** Martin