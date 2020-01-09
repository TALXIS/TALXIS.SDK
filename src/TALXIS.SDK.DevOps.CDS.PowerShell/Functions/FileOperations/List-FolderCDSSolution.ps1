
function List-FolderCDSSolution {
    param(
        [string]$folderPath
    )

    $fileList = New-Object System.Collections.ArrayList($null)

    [void][Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
    foreach($sourceFile in (Get-ChildItem -Path $folderPath -Filter '*.zip' -Recurse))
    {
            $zip = [IO.Compression.ZipFile]::OpenRead($sourceFile.FullName);
            $entry = $zip.Entries | Where-Object { $_.FullName -eq "solution.xml" } | Select -First 1
            $zip.Dispose()
            if ($entry) { [void]$fileList.Add($sourceFile) }
    }

    return $fileList
}