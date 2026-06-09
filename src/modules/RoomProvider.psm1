# Läser in rum från data/rooms.json och returnerar dem som Powershellobjekt.
# RoomProvider anropas av GameEngine.psm1

# RoomProvider.psm1

function Get-Rooms {
    # 1. Bygg sökvägen till filen rooms.json
    $roomsPath = Join-Path $PSScriptRoot "..\..\data\rooms.json"
    
    # 2. Kontrollera att filen existerar
    if (-not (Test-Path $roomsPath)) {
        throw "Kunde inte hitta rooms.json på: $roomsPath"
    }
    
    try {
        # 3. Läs in filinnehållet och konvertera från JSON till ett PowerShell-objekt
        $jsonContent = Get-Content -Raw -Path $roomsPath -Encoding UTF8 -ErrorAction Stop
        return @(ConvertFrom-Json $jsonContent -ErrorAction Stop)
    }
    catch {
        throw "Kritiskt fel: Filen rooms.json är skadad eller har ogiltigt JSON-format. Detaljer: $_"
    }
}
# Söker ut och returnerar ett specifikt rum baserat på dess unika ID, kommer att användas av spelmotorn för att hämta nästa scenario när en spelare går vidare.
function Get-RoomById ([string]$RoomId) {
    $rooms = Get-Rooms
    return $rooms | Where-Object { $_.Id -eq $RoomId }
}

Export-ModuleMember -Function Get-Rooms, Get-RoomById