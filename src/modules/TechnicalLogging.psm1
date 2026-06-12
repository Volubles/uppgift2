# TechnicalLogging.psm1
# Hanterar teknisk loggning av spelhändelser.
# Modulen innehåller ingen spellogik.

function Get-LogFilePath {
    try {
        $projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
        $logDirectory = Join-Path $projectRoot "logs"

        if (-not (Test-Path $logDirectory)) {
            New-Item -Path $logDirectory -ItemType Directory | Out-Null
        }

        $date = Get-Date -Format "yyyy-MM-dd"
        return (Join-Path $logDirectory "game-$date.jsonl")
    }
    catch {
        return $null
    }
}


function Write-LogEvent {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Event,

        [string]$Message = "",

        [ValidateSet("INFO", "WARN", "ERROR")]
        [string]$Level = "INFO",

        [hashtable]$Data = @{}
    )

    try {
        $logFilePath = Get-LogFilePath

        if ([string]::IsNullOrWhiteSpace($logFilePath)) {
            return $false
        }

        $logEntry = [pscustomobject]@{
            Timestamp = Get-Date -Format "o"
            Level     = $Level
            Event     = $Event
            Message   = $Message
            Data      = $Data
        }

        $jsonLine = $logEntry | ConvertTo-Json -Depth 6 -Compress
        Add-Content -Path $logFilePath -Value $jsonLine -Encoding UTF8

        return $true
    }
    catch {
        return $false
    }
}


Export-ModuleMember -Function Get-LogFilePath, Write-LogEvent
