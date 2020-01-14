# $ErrorActionPreference = 'Stop'
$parent="$((get-item $PSScriptRoot).parent.FullName)"
$tests="$parent\tests"
$src="$parent\src"
$publish="$parent\publish"