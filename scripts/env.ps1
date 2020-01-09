$parent="$((get-item $PSScriptRoot).parent.FullName)"
$tests="$parent\tests"
$src="$parent\src"
$publish="$parent\publish"

function Invoke-GitVersions(){
    GitVersion.exe /output buildserver
    Write-host $env:MajorMinorPatch
}