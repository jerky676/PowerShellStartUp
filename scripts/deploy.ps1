. "$PSScriptRoot\env.ps1"

if ($env:APPVEYOR_REPO_BRANCH -eq "Master"){
    Write-host "Deploying branch $env:APPVEYOR_REPO_BRANCH"
    Invoke-GitVersions
    #deploy 
} else {
    #do not deploy
    Write-host "Not deploying branch $env:APPVEYOR_REPO_BRANCH"
}

