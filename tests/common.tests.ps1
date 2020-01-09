$parent="$((get-item $PSScriptRoot).parent.FullName)"
$publish="$parent\publish"
$manifest="$publish\PSStartUp.psd1"
$module="$publish\PSStartUp.psm1"


function Build-Manifest(){
    . "$parent\scripts\buildManifest.ps1" 0.0.1
}

