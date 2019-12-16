
$ignorefiles=@("common.tests")

foreach ($test in @( Get-ChildItem -Path $PSScriptRoot\tests\*.ps1 -Recurse  | where-object { $ignorefiles -NotContains $_.basename  })){
        . "$test"
}