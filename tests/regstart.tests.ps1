. "$((get-item $PSScriptRoot).parent.FullName)\scripts\env.ps1"

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
    Build-Manifest "$testpublish" 0.0.1
    Import-Module "$testpublish\$moduleName.psm1" -Force
    $duration = $(Measure-Command { Test-AddGetRemove | out-null })

    if ($env:APPVEYOR){
        Add-AppveyorTest -Name ModuleTest -Outcome Passed -Duration $duration.TotalMilliseconds
    }    
} catch {
    write-host "Caught an exception: $($_.Exception)" -ForegroundColor Red
    $_
    if ($env:APPVEYOR){
        Add-AppveyorTest -Name ModuleTest -Outcome Failed -ErrorMessage "$ErrorMessage" -ErrorStackTrace "$_.Exception.ErrorStackTrace"  -Duration $duration.TotalMilliseconds
    }
    $exitCode=1
}
finally{
    if (Get-Module -ListAvailable -Name "$modulename") {
        Remove-Module -Name "$moduleName" | Out-Null
    } 
    exit $exitCode
}