param(
  [string]$Version = ''
)

. "$PSScriptRoot\env.ps1"


$moduleName="PSStartUp"
$manifestFileName="$publish\$moduleName.psd1"
$guid="f221d635-8972-4c88-a916-00ca846f2057"
$author="Justin Luther"
$companyname="Datafounder"
$description="This is a simple PowerShell Module to Add/Remove/Get PS Scripts that start up via the Registry key."
$psVersion = "5.0"
$tags=@("Start Up","Windows","Registry")
$licenseUri = 'https://github.com/jerky676/PowerShellStartUp/blob/master/LICENSE.md'
$projectUri = 'https://github.com/jerky676/PowerShellStartUp'
$helpInfoUri = "https://github.com/jerky676/PowerShellStartUp/wiki"
$ErrorActionPreference = 'Stop'

# if ($env:APPVEYOR_BUILD_VERSION) {
#     write-host $env:APPVEYOR_BUILD_VERSION
#     $Version = [regex]::match($env:APPVEYOR_BUILD_VERSION,'[0-9]+\.[0-9]+\.[0-9]+').Groups[0].Value
#     $lastPublishedVersion = [Version]::new((Find-Module -Name JournalCli | Select-Object -ExpandProperty Version))
#     if ([Version]::new($Version) -le $lastPublishedVersion) {
#         Write-Host "Last published version: 'v$lastPublishedVersion'. Current version: 'v$Version'"
#         throw "Version must be greater than the last published version, which is 'v$lastPublishedVersion'."
#     }
#     Write-Host "Last published version: 'v$lastPublishedVersion'. Current version: 'v$Version'"
# } elseif ($Version -eq '') {

#   throw "Missing version parameter"
# }


if (Test-Path "$publish") {
    Remove-Item -Path "$publish" -Recurse -Force
}

Copy-Item -path "$src\" -Destination "$publish\" -Recurse


$currentFunctions = Get-ChildItem function:
$public = @( Get-ChildItem -Path "$src\public\*.ps1" -Recurse )
# dot source your script to load it to the current runspace

Foreach($import in @($public))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

$scriptFunctions = Get-ChildItem function: | Where-Object { $currentFunctions -notcontains $_ }
$rootmodule=Get-ChildItem -Path "$src\*.psm1"


$newManifestArgs = @{
    Path = "$manifestFileName"
}
  
$updateManifestArgs = @{
    Path = "$manifestFileName"
    RootModule = "$rootmodule"
    CopyRight = "(c) $((Get-Date).Year) $companyname. All rights reserved."
    Description = "$description"
    Guid = "$guid"
    Author = "$author"
    CompanyName = "$companyname"
    ModuleVersion = $Version
    AliasesToExport = $scriptFunctions
    FunctionsToExport = $scriptFunctions
    HelpInfoUri = $helpInfoUri
    PowerShellVersion = $psVersion
    PrivateData = @{
        Tags = $tags
        LicenseUri = "$licenseUri"
        ProjectUri = "$projectUri"
    }
}

New-ModuleManifest @newManifestArgs
Update-ModuleManifest @updateManifestArgs