# tests/Test-LoggingSystem.ps1
# Testar att LoggingSystem.psm1 kan importeras och skriva en teknisk logghändelse.

$ErrorActionPreference = "Stop"

$modulePath = ".\src\modules\LoggingSystem.psm1"

if (-not (Test-Path $modulePath)) {
    throw "LoggingSystem.psm1 saknas."
}

Remove-Module LoggingSystem -Force -ErrorAction SilentlyContinue
Import-Module $modulePath -Force

if (-not (Get-Command Write-LogEvent -ErrorAction SilentlyContinue)) {
    throw "Write-LogEvent saknas."
}

if (-not (Get-Command Get-LogFilePath -ErrorAction SilentlyContinue)) {
    throw "Get-LogFilePath saknas."
}

$result = Write-LogEvent -Event "TestEvent" -Message "Test av teknisk loggning." -Data @{
    Test = $true
    Source = "Test-LoggingSystem"
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

Write-Host "PASS: LoggingSystem skapade loggfil och skrev testhändelse."
Write-Host "Loggfil: $logFilePath"
