. "$PSScriptRoot\env.ps1"


# TODO: add semver check

write-host "branch: $env:APPVEYOR_REPO_BRANCH pull request number $env:APPVEYOR_PULL_REQUEST_NUMBER"

if ($env:APPVEYOR_REPO_BRANCH -eq "Master" -and $env:APPVEYOR_PULL_REQUEST_NUMBER -eq $NULL ){
    Write-host "Deploying branch $env:APPVEYOR_REPO_BRANCH"
    git config --global credential.helper store
    Add-Content "$HOME\.git-credentials" "https://$($env:GitHubAccessToken):x-oauth-basic@github.com`n"
    git config --global user.email "$env:GitHubEmail"
    git config --global user.name "$env:GitHubUserName"
    git config --global push.followTags true
    git tag -msg $env:GitVersion_SemVer $env:GitVersion_Sha
    git push origin --tags
    Write-host "Deployed"
}