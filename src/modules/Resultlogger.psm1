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