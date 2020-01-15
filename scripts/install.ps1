$ErrorActionPreference = 'Stop'

write-host "Install GitVersion"
choco install gitversion.portable | out-null
write-host "Output gitversion variable to env"
GitVersion.exe /output buildserver | out-null