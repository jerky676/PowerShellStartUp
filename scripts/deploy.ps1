. "$PSScriptRoot\env.ps1"

if ($env:APPVEYOR_REPO_BRANCH -eq "Master"){
    Write-Host "Deploying branch $env:APPVEYOR_REPO_BRANCH"
    . "$parent\scripts\buildManifest.ps1" $env:GitVersion_SemVer
    Publish-Module -NuGetApiKey $env:NugetAPIKey -Path "$publish"
}
