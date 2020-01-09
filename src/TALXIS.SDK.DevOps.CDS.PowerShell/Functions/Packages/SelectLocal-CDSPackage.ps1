function SelectLocal-CDSPackage {
    $folder = Select-CDSBuildFolder
    $packagesInFolder = List-ColderCDSPackage $folder | Where-Object {$_.FullName}
}