$registryPath="Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"

function Add-StartUpScript([string]$filename,[string]$name,[switch]$force){   
    $keyexists = $(Get-StartUpKeyExists -name $name)
    $filename = $(Get-ResolvedPath $filename)
    $command="""Powershell.exe"" ""$filename"" --windowstyle hidden"

    if ($keyexists -and ! $force){
        write-host "$name already exists use -force"
    } elseif ($keyexists -and $force){
        Remove-ItemProperty -Path "$registryPath" -Name $name
        New-ItemProperty -Path "$registryPath" -Name $name -Value $command
        write-host "$name overwritten"
    } else {
        New-ItemProperty -Path "$registryPath" -Name $name -Value $command
        write-host "$name created"
    }
}

function Remove-StartUpScript([string]$name){
    Remove-ItemProperty -Path "$registryPath" -Name $name
}

function Get-StartUpScripts(){
    (Get-ItemProperty $registryPath).psobject.properties | Select name, value
}

function Get-StartUpScript([string]$name){
    (Get-ItemProperty $registryPath).psobject.properties | where {$_.name -like "$name" -or $_.value -like "$name"} | Select name, value
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