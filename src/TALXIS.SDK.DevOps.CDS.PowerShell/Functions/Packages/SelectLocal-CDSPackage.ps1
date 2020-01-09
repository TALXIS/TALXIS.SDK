function SelectLocal-CDSPackage {
    $folder = Select-CDSBuildFolder
    $packagesInFolder = List-FolderCDSPackage $folder | Where-Object {$_.FullName}
}