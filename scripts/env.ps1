# $ErrorActionPreference = 'Stop'
$parent="$((get-item $PSScriptRoot).parent.FullName)"
$tests="$parent\tests"
$src="$parent\src"
$srcPublic="$src\public"
$srcPrivate="$src\private"
$scripts="$parent\scripts"
$moduleName="PSStartUp"
$outdir="$parent\out"
$testpublish="$outdir\test"
$publish="$outdir\$moduleName"
$manifestFileName="$moduleName.psd1"
$module="$publish\PSStartUp.psm1"
$guid="f221d635-8972-4c88-a916-00ca846f2057"
$author="Justin Luther"
$companyname="Datafounder"
$description="This is a simple PowerShell Module to Add/Remove/Get PS Scripts that start up via the Registry key."
$psVersion = "5.0"
$tags=@("Start","Up","Windows","Registry")
$licenseUri = 'https://github.com/jerky676/PowerShellStartUp/blob/master/LICENSE.md'
$projectUri = 'https://github.com/jerky676/PowerShellStartUp'
$helpInfoUri = "https://github.com/jerky676/PowerShellStartUp/wiki"


. "$scripts\functions.ps1"