# tests/Test-TechnicalLogging.ps1
# Testar att TechnicalLogging.psm1 kan importeras och skriva en teknisk logghändelse.

$ErrorActionPreference = "Stop"

$modulePath = ".\src\modules\TechnicalLogging.psm1"

if (-not (Test-Path $modulePath)) {
    throw "TechnicalLogging.psm1 saknas."
}

Remove-Module TechnicalLogging -Force -ErrorAction SilentlyContinue
Import-Module $modulePath -Force

if (-not (Get-Command Write-LogEvent -ErrorAction SilentlyContinue)) {
    throw "Write-LogEvent saknas."
}

if (-not (Get-Command Get-LogFilePath -ErrorAction SilentlyContinue)) {
    throw "Get-LogFilePath saknas."
}

$result = Write-LogEvent -Event "TestEvent" -Message "Test av teknisk loggning." -Data @{
    Test = $true
    Source = "Test-TechnicalLogging"
}

if (-not $result) {
    throw "Write-LogEvent returnerade false."
}

$logFilePath = Get-LogFilePath

if (-not (Test-Path $logFilePath)) {
    throw "Loggfilen skapades inte."
}

$content = Get-Content $logFilePath -Raw

if ($content -notmatch "TestEvent") {
    throw "Loggfilen innehåller inte testhändelsen."
}

Write-Host "PASS: TechnicalLogging skapade loggfil och skrev testhändelse."
Write-Host "Loggfil: $logFilePath"
