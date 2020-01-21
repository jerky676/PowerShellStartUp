function Build-Manifest([string]$outDir,[string]$Version = ''){
	write-host "Clear old build directory $outDir"
	Remove-Directory $outDir
	write-host "Add build directory $outDir"
	Add-Directory $outDir

	Build-Module $outDir

	$currentFunctions = Get-ChildItem function:
	$public = @( Get-ChildItem -Path "$src\public\*.ps1" -Recurse )
	$private = @( Get-ChildItem -Path "$src\private\*.ps1" -Recurse )

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
	
	write-host "$outDir\$manifestFileName"

	$newManifestArgs = @{
		Path = "$outDir\$manifestFileName"
		# RootModule = "$rootmodule"
		# CopyRight = "(c) $((Get-Date).Year) $companyname. All rights reserved."
		# Description = "$description"
		# Guid = "$guid"
		# Author = "$author"
		# CompanyName = "$companyname"
		# ModuleVersion = $Version
	}
	
	$updateManifestArgs = @{
		Path = "$outDir\$manifestFileName"
		RootModule = "$rootmodule"
		# NestedModules = @($public + $private)
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
	sleep 1
	Update-ModuleManifest @updateManifestArgs
}

function Add-Directory([string]$dir){
    if (! $(Test-Path "$dir")) {
        New-Item -Path "$dir" -ItemType "Directory" | out-null
    }  
}

function Remove-Directory([string]$dir){
    if (Test-Path "$dir") {
		write-host "Removed $dir"
        Remove-Item -Path "$dir" -Recurse -Force
    }
}

function Build-Module([string]$dir){
    Copy-Item -path "$src\*" -Destination "$dir" -Recurse 
}