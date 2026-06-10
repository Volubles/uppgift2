function Get-Teori {
    # 1. Bygg sökvägen till filen teorin.json
    $teorinPath = Join-Path $PSScriptRoot "..\..\data\teorin.json"

    # 2. Kontrollera att filen existerar
    if (-not (Test-Path $teorinPath)) {
        throw "Kunde inte hitta teorin.json på: $teorinPath"
    }

    try {
        # 3. Läs in filinnehållet och konvertera från JSON till PowerShell-objekt
        $jsonContent = Get-Content -Raw -Path $teorinPath -Encoding UTF8 -ErrorAction Stop
        return @(ConvertFrom-Json $jsonContent -ErrorAction Stop)
    }
    catch {
        throw "Kritiskt fel: Filen teorin.json är skadad eller har ogiltigt JSON-format. Detaljer: $_"
    }
}

# Hämtar teorin kopplad till ett specifikt rum baserat på rummets ID.
function Get-TeoriByRoomId {
    param (
        [string]$RoomId
    )

    $theorier = Get-Teori
    return $theorier | Where-Object { $_.RelatedRoomId -eq $RoomId }
}

# Exporterar funktionerna så att de kan användas av andra PowerShell-filer/moduler.
Export-ModuleMember -Function Get-Teori, Get-TeoriByRoomId