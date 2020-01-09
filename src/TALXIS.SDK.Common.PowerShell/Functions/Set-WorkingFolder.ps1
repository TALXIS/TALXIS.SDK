function Set-WorkingFolder {
    param (
        [string] $Path
    )
    $rootFolder = (get-item $PSScriptRoot).parent.parent.FullName
    $Path = "$rootFolder\_TEMPWORKINGDIR\"
    New-Item -ItemType Directory -Force -Path $Path
    $global:workingDirPath = Resolve-Path -Path $Path
}