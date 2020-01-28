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
	$rootmodule=$(Get-ChildItem -Path "$src\*.psm1").Name
	
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

function Test-Assertion 
{ 
<# 
.Synopsis 
A PowerShell assert function. 
.Description 
A PowerShell assert function. 
 
An assert function is used to display errors when some condition is not true. The error message will typically contain the file, line number, and the line of code that caused the failing assertion. 
 
This function throws an error in these conditions: 
* assertion is $false 
* assertion is $null 
* assertion is not of type System.Boolean 
* Test-Assertion is used in a pipeline and multiple values are piped 
* Test-Assertion is used in a pipeline and no values are piped 
.Example 
Test-Assertion (0 -le (get-random -minimum 0 -maximum 10)) 
Tests that 0 is less than or equal to the value returned from the get-random function call. 
.Example 
Test-Assertion (0 -le (get-random -minimum 0 -maximum 10)) -Verbose -Debug 
Use the -Verbose and -Debug switches in Test-Assertion to help investigate failing assertions. 
 
-Verbose displays information about passing assertions 
-Debug gives you a chance to debug a failing assertion 
.Example 
0 -le (get-random -minimum 0 -maximum 10) | Test-Assertion -Verbose -Debug 
Use Test-Assertion in a pipeline. 
 
Note: 
If Test-Assertion is used in a pipeline, Test-Assertion will fail if more than one value is piped or if no values are piped. 
.Inputs 
System.Boolean 
System.Object 
.Outputs 
None 
#> 
    [CmdletBinding()] 
    Param( 
        #The value to assert. 
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)] 
        [AllowNull()] 
        [AllowEmptyCollection()] 
        [System.Object] 
        $InputObject 
    ) 
 
    Begin 
    { 
        $info = '{0}, file {1}, line {2}' -f @( 
            $MyInvocation.Line.Trim(), 
            $MyInvocation.ScriptName, 
            $MyInvocation.ScriptLineNumber 
        ) 
        $inputCount = 0 
        $inputFromPipeline = -not $PSBoundParameters.ContainsKey('InputObject') 
    } 
 
    Process 
    { 
        $inputCount++ 
        if ($inputCount -gt 1) { 
            $message = "Assertion failed (more than one object piped to Test-Assertion): $info" 
            Write-Debug -Message $message 
            throw $message 
        } 
        if ($null -eq $InputObject) { 
            $message = "Assertion failed (`$InputObject is `$null): $info" 
            Write-Debug -Message $message 
            throw  $message 
        } 
        if ($InputObject -isnot [System.Boolean]) { 
            $type = $InputObject.GetType().FullName 
            $value = if ($InputObject -is [System.String]) {"'$InputObject'"} else {"{$InputObject}"} 
            $message = "Assertion failed (`$InputObject is of type $type with value $value): $info" 
            Write-Debug -Message $message 
            throw $message 
        } 
        if (-not $InputObject) { 
            $message = "Assertion failed (`$InputObject is `$false): $info" 
            Write-Debug -Message $message 
            throw $message 
        } 
        Write-Verbose -Message "Assertion passed: $info" 
    } 
 
    End 
    { 
        if ($inputFromPipeline -and $inputCount -lt 1) { 
            $message = "Assertion failed (no objects piped to Test-Assertion): $info" 
            Write-Debug -Message $message 
            throw $message 
        } 
    } 
} 