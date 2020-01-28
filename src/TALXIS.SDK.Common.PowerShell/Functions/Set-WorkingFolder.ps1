function Set-WorkingFolder {
    param (
        [string] $Path
    )
    $tempFolder = (Join-Path -Path ([IO.Path]::GetTempPath()) -ChildPath "TALXIS.SDK.TempFolder")
    mkdir -p $tempFolder
    $global:workingDirPath = $tempFolder
}