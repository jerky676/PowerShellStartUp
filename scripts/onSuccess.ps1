. "$PSScriptRoot\env.ps1"

if ($env:APPVEYOR_REPO_BRANCH -eq "Master"){
    Write-host "Sucess branch $env:APPVEYOR_REPO_BRANCH"
    git config --global credential.helper store
    Add-Content "$HOME\.git-credentials" "https://$($env:GitHubAccessToken):x-oauth-basic@github.com`n"
    git config --global user.email "$env:GitHubEmail"
    git config --global user.name "$env:GitHubUserName"
    GitVersion.exe /output buildserver
    git tag -msg $env:GitVersion_SemVer $env:GitVersion_Sha
} else {
    #do not deploy
    Write-host "Sucess non master branch $env:APPVEYOR_REPO_BRANCH"
}