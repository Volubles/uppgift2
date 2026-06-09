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

Vill man testa modulen SaveSystem.psm1 oberoende av något annat så kan se till att stå i projektmappen i terminalen och kopiera in följande i terminalen (modifiera efter eget tycke och smak):

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