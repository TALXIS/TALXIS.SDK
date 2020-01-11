function Find-BuildFolderCDSPackage {
    param(
        [string]$folderPath,
        [string]$packageName
    )
    
    $packageDll = Get-ChildItem -Path $folderPath -Filter "$packageName.dll" -Recurse | Select -First 1
    $packageBuildFolder = $packageDll.Directory
    write-host "Package build directory is $packageBuildFolder"

    return $packageBuildFolder
}