. "$PSScriptRoot\env.ps1"

$ErrorActionPreference = 'Stop'

if ($env:APPVEYOR_REPO_BRANCH -eq "Master"){
    Write-host "Sucess branch $env:APPVEYOR_REPO_BRANCH"
    git config --global credential.helper store
    Add-Content "$HOME\.git-credentials" "https://$($env:GitHubAccessToken):x-oauth-basic@github.com`n"
    git config --global user.email "$env:GitHubEmail"
    git config --global user.name "$env:GitHubUserName"
    git config --global push.followTags true
    git tag -msg $env:GitVersion_SemVer $env:GitVersion_Sha
    git push
    Write-host "Deployed"
}