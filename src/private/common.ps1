function Get-ResolvedPath([string]$file) {
    if ($file -match '^[a-zA-Z]:'){
        return "$file"
    }
    if ($file -match '(\/|\\)'){
        return $(Resolve-Path -path "$file")
    } else {
        return "$(Get-Location)\$file"
    }    
}

function Get-CommandFromScriptExt([string]$filename){
    switch ($([System.IO.Path]::GetExtension("$filename")))
    {
        ".ps1" { return """Powershell.exe"" ""$filename"" --windowstyle hidden" }
        ".cmd" { return """cmd.exe"" ""$filename"""}
        ".bat" { return """cmd.exe"" ""$filename"""}
        ".vbs" { return """cmd.exe"" cscript //logo ""$filename"""}
        ".js" { return """node.exe"" ""$filename"""}
        default { return """cmd.exe"" ""$filename"""}
    }
}

function Add-StartUp([string]$name,[string]$command,[switch]$force){
    $keyexists = $(Get-StartUpKeyExists -name $name)
    if ($keyexists -and ! $force){
        return "$name already exists use -force"
    } elseif ($keyexists -and $force){
        Remove-ItemProperty -Path "$registryPath" -Name $name
        New-ItemProperty -Path "$registryPath" -Name $name -Value $command
        return "$name overwritten"
    } else {
        New-ItemProperty -Path "$registryPath" -Name $name -Value $command
        return "$name created"
    }
}

function Get-StartUpKeyExists([string]$name){
    if (Test-Path $registryPath){
        $Key = Get-Item -LiteralPath $registryPath
        if ($Key.GetValue($Name, $null) -ne $null) {
            return $true
        } else {
            return $false
        }
    }
}