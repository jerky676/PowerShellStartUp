. "$PSScriptRoot\common.tests.ps1"

function Test-AddGetRemove(){
    $name="testhis"
    Add-StartUpScript "test.ps1" $name | Out-Null   
    if (! (Get-StartUpScript $name)){
        throw "Was not able to create script"
    } else { 
        Remove-StartUpScript $name | Out-Null
    }
    Get-StartUpScripts | Out-Null
}


$exitCode=0

Try{
    Build-Manifest
    Import-Module "$module" -Force
    $duration = $(Measure-Command { Test-AddGetRemove | out-null })
    Add-AppveyorTest -Name ModuleTest -Outcome Passed -Duration $duration.TotalMilliseconds
} catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    write-host "$ErrorMessage $FailedItem"
    Add-AppveyorTest -Name ModuleTest -Outcome Failed -ErrorMessage "$ErrorMessage" -ErrorStackTrace "$_.Exception.ErrorStackTrace"  -Duration $duration.TotalMilliseconds
    $exitCode=1
}
finally{
    Remove-Module -Name "PSStartUp" | Out-Null
    exit $exitCode
}