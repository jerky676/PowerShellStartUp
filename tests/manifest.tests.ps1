. "$PSScriptRoot\common.tests.ps1"

$exitCode=0

Try{
    Build-Manifest
    $duration = $(Measure-Command { Test-ModuleManifest -path "$manifest" | out-null })
    Add-AppveyorTest -Name ManifestTest -Outcome Passed -Duration $duration.TotalMilliseconds
}catch{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Add-AppveyorTest -Name ManifestTest-Outcome Failed -ErrorMessage "$ErrorMessage" -ErrorStackTrace "$_.Exception.ErrorStackTrace"  -Duration $duration.TotalMilliseconds
    $exitCode=1
}
finally{
    exit $exitCode
}