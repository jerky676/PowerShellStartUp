. "$((get-item $PSScriptRoot).parent.FullName)\scripts\env.ps1"

. "$srcPrivate\common.ps1"

function Test-CommonFunctions(){
    Test-Assertion ($(Get-CommandFromScriptExt "file.ps1") -eq """Powershell.exe"" ""file.ps1"" --windowstyle hidden")
    Test-Assertion ($(Get-CommandFromScriptExt "file.cmd") -eq """cmd.exe"" ""file.cmd""")
    Test-Assertion ($(Get-CommandFromScriptExt "file.bat") -eq """cmd.exe"" ""file.bat""")
    Test-Assertion ($(Get-CommandFromScriptExt "file.vbs") -eq """cmd.exe"" cscript //logo ""file.vbs""")
    Test-Assertion ($(Get-CommandFromScriptExt "file.js") -eq """node.exe"" ""file.js""")
    Test-Assertion ($(Get-CommandFromScriptExt "file.def") -eq """cmd.exe"" ""file.def""")
}

$exitCode=0

Try{
    $duration = $(Measure-Command { Test-CommonFunctions | out-null })

    if ($env:APPVEYOR){
        Add-AppveyorTest -Name CommonTest -Outcome Passed -Duration $duration.TotalMilliseconds
    }    
} catch {
    write-host "Caught an exception: $($_.Exception)" -ForegroundColor Red
    $_
    if ($env:APPVEYOR){
        Add-AppveyorTest -Name CommonTest -Outcome Failed -ErrorMessage "$ErrorMessage" -ErrorStackTrace "$_.Exception.ErrorStackTrace"  -Duration $duration.TotalMilliseconds
    }
    $exitCode=1
}
finally{
    if (Get-Module -ListAvailable -Name "$modulename") {
        Remove-Module -Name "$moduleName" | Out-Null
    } 
    exit $exitCode
}