. "$PSScriptRoot\env.ps1"

$ignorefiles=@("common.tests")

foreach ($test in @( Get-ChildItem -Path $tests\*.ps1 -Recurse  | where-object { $ignorefiles -NotContains $_.basename  })){
        . "$test"
}