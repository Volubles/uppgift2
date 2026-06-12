# ResultLogger.psm1
# Skickar resultatet från spelet till en GitHub Gist via GitHub API.
# Autentisering: token + Gist-ID läses från config.ps1 (eller miljövariabler).

function Initialize-ResultLogger {
    # Läser konfigurationen. Prioritet: miljövariabler -> config.ps1
    $token  = $env:GITHUB_TOKEN
    $gistId = $env:GIST_ID
 
    # Om token eller gist_id inte hittas i miljövariabler, försök läsa från config.ps1
    if ([string]::IsNullOrEmpty($token) -or [string]::IsNullOrEmpty($gistId)) {
        $configPath = Join-Path $PSScriptRoot "..\..\config.ps1"
        if (Test-Path $configPath) {
            . $configPath
            $token  = $GITHUB_TOKEN
            $gistId = $GIST_ID
        }
    }
    # Om båda fortfarande är tomma, kasta ett fel.
    if ([string]::IsNullOrEmpty($token) -or [string]::IsNullOrEmpty($gistId)) {
        throw "Loggning ej konfigurerad. Skapa config.ps1 (se config.template.ps1)."
    }
 
    return @{ Token = $token; GistId = $gistId }
}

# Tar emot spelarens resultat plus $Config (det som Initialize-ResultLogger returnerar)
function Write-ResultToGist ($PlayerName, $Score, $Total, $WeakAreas, $Config) {
    try {
        # Autentiseringsheader och API-endpoint
        $headers = @{
            "Authorization" = "Bearer $($Config.Token)"
            "Accept"        = "application/vnd.github+json"
        }
        $uri = "https://api.github.com/gists/$($Config.GistId)"

        # Hämtar gistens nuvarande innehåll
        $gist = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -ErrorAction Stop

        # En Gist kan innehålla flera filer, vi letar specifikt efter results-log.md
        $logFileName = "results-log.md"
        $befintligLogg = $null
        if ($gist.files.PSObject.Properties[$logFileName]) {
            $befintligLogg = $gist.files.$logFileName.content
        }
        # Om loggfilen inte finns, skapa en ny med en header
        if ([string]::IsNullOrEmpty($befintligLogg)) {
            $befintligLogg = "# Security Escape Room - Resultatlogg`n`n| Spelare | Datum | Resultat | Godkänd | Svaga områden |`n|---|---|---|---|---|"
        }
}
