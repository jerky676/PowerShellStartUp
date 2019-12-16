. "$PSScriptRoot\common.tests.ps1"

$exitCode=0

Try{
    Build-Manifest
    Test-ModuleManifest -path "$manifest" | out-null
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    write-host "$ErrorMessage $FailedItem"
    $exitCode=1
}
finally{
    exit $exitCode
}