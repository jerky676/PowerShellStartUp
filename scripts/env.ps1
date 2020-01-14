$parent="$((get-item $PSScriptRoot).parent.FullName)"
$tests="$parent\tests"
$src="$parent\src"
$publish="$parent\publish"

function Add-GitAccessToken(){
    git config --global credential.helper store
    Add-Content "$HOME\.git-credentials" "https://$($env:GitHubAccessToken):x-oauth-basic@github.com`n"
    git config --global user.email "$env:GitHubEmail"
    git config --global user.name "$env:GitHubUserName"
}


function Invoke-GitVersions(){
    GitVersion.exe /output buildserver
}

function Tag-Version(){
    git tag -msg $env:GitVersion_SemVer $env:GitVersion_Sha
}