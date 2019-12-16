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