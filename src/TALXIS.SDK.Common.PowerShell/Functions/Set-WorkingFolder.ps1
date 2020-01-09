function Set-WorkingFolder {
    param (
        [string] $Path = ".\_TEMPWORKINGDIR\"
    )
    
    New-Item -ItemType Directory -Force -Path $Path
    $global:workingDirPath = Resolve-Path -Path $Path
}