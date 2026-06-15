# Skapa config.ps1 i projektroten och kopiera innehållet här till den och fyll i dina egna värden. Denna fil används av ResultLogger för att autentisera mot GitHub API och logga resultaten i en Gist.
# config.ps1 ligger i .gitignore och hamnar därför aldrig på GitHub.

# GitHub Personal Access Token (börjar med "github_pat_")
$GITHUB_TOKEN = "YOUR_GITHUB_TOKEN_HERE"

# Gist-ID (den långa strängen sist i Gist-länken)
$GIST_ID = "YOUR_GIST_ID_HERE"