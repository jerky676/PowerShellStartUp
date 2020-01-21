. "$PSScriptRoot\env.ps1"
$ErrorActionPreference = 'Stop'

write-host "semver: $env:GitVersion_SemVer"
Write-host "Branch: $env:APPVEYOR_REPO_BRANCH"
write-host "Commit $env:GitVersion_Sha"

# if ($env:APPVEYOR_REPO_BRANCH -eq "Master"){
#     write-host "Master branch"
# }