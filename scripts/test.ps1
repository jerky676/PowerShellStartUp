. "$PSScriptRoot\env.ps1"

$ErrorActionPreference = 'Stop'

$ignorefiles=@("common.tests")

foreach ($test in @( Get-ChildItem -Path $tests\*.ps1 -Recurse  | where-object { $ignorefiles -NotContains $_.basename  })){
    write-host "Running test script $test"
    . "$test"
}