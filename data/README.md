# data/rooms.json 

Filen `rooms.json` Innehåller spelets rum, frågor och svarsalternativ.

Filen läses av:
`src/modules/RoomProvider.psm1`

## Room-kontrakt

Varje rum ska ha:

- Id
- Title
- Description
- Options
- CorrectOption
- SuccessText
- FailureText
- NextRoomId

## Princip

JSON = innehåll  
PowerShell = logik

Då slipper vi hårdkoda materialet i powershell med if else satser.