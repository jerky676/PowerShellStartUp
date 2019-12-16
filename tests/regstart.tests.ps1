. "$PSScriptRoot\common.tests.ps1"

Build-Manifest

Import-Module "$module" -Force

$exitCode=0

Try{
    $name="testhis"
    Add-StartUpScript "test.ps1" $name | Out-Null
    
    if (! (Get-StartUpScript $name)){
        throw "Was not able to create script"
    } else { 
        Remove-StartUpScript $name | Out-Null
    }
    Get-StartUpScripts | Out-Null
} catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    write-host "$ErrorMessage $FailedItem"
    $exitCode=1
}
finally{
    Remove-Module -Name "PSStartUp" | Out-Null
    exit $exitCode
}