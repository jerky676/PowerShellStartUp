$parent="$((get-item $PSScriptRoot).parent.FullName)"
$scripts="$parent\scripts"
. "$scripts\env.ps1"


function Build-Manifest(){
    . "$scripts\buildManifest.ps1" 0.0.1
}