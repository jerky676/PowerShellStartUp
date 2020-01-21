. "$((get-item $PSScriptRoot).parent.FullName)\scripts\env.ps1"
. "$PSScriptRoot\common.tests.ps1"

$exitCode=0

Try{
    Build-Manifest "$testpublish" 0.0.1
    $duration = $(Measure-Command { Test-ModuleManifest -path "$testpublish\$manifestfilename" | out-null })
    if ($env:APPVEYOR){
        Add-AppveyorTest -Name ManifestTest -Outcome Passed -Duration $duration.TotalMilliseconds
    }
}catch{
    $_
    if ($env:APPVEYOR){
        Add-AppveyorTest -Name ManifestTest-Outcome Failed -ErrorMessage "$_.Exception.Message" -ErrorStackTrace "$_.Exception.ErrorStackTrace"  -Duration $duration.TotalMilliseconds
    }
    $exitCode=1
}
finally{
    write-host "Completed"
    exit $exitCode
}