$registryPath="Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"

function Add-StartUpScript([string]$filename,[string]$name,[switch]$force){   
    Add-StartUp -name $name -command "$(Get-CommandFromScriptExt $(Get-ResolvedPath $filename))" -force $force
}

function Add-StartUpProgram([string]$filename,[string]$name,[string[]]$arguments,[switch]$force){
    Add-StartUp -name $name -command "$filename $arguments" -force $force
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