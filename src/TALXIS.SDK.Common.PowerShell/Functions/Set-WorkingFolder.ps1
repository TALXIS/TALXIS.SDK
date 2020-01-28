function Set-WorkingFolder {
    param (
        [string] $Path
    )
    $tempFolder = (Join-Path -Path ([IO.Path]::GetTempPath()) -ChildPath "TALXISTempFolder")
    mkdir -p $tempFolder
    $global:workingDirPath = $tempFolder
}