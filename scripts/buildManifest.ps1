param(
  [string]$Version = ''
)

. "$PSScriptRoot\env.ps1"

$ErrorActionPreference = 'Stop'

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