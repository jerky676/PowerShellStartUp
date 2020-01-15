. "$PSScriptRoot\env.ps1"
$ErrorActionPreference = 'Stop'

write-host "semver: $env:GitVersion_SemVer"
Write-host "Branch: $env:APPVEYOR_REPO_BRANCH"
write-host "Commit $env:GitVersion_Sha"

if (Test-Path "$publish") {
    Remove-Item -Path "$publish" -Recurse -Force
}

Copy-Item -path "$src\" -Destination "$publish\" -Recurse

$currentFunctions = Get-ChildItem function:
$public = @( Get-ChildItem -Path "$src\public\*.ps1" -Recurse )



# if ($env:APPVEYOR_REPO_BRANCH -eq "Master"){
#     write-host "Master branch"
# }