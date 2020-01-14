. "$PSScriptRoot\env.ps1"

if ($env:APPVEYOR_REPO_BRANCH -eq "Master"){
    Write-Host "Deploying branch $env:APPVEYOR_REPO_BRANCH"
} else {
    #do not deploy
    Write-host "Not deploying branch $env:APPVEYOR_REPO_BRANCH"
}
