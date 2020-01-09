$parent="$((get-item $PSScriptRoot).parent.FullName)"
$tests="$parent\tests"
$src="$parent\src"
$publish="$parent\publish"

function Invoke-GitVersions(){
    GitVersion.exe /output buildserver
}

function Tag-Version(){
    git tag -msg $env:GitVersion_SemVer $env:GitVersion_Sha
}