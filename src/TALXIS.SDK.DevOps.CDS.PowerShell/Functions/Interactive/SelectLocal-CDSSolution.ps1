function SelectLocal-CDSSolution {
    $folder = Select-CDSBuildFolder
    $solutionsInFolder = List-FolderCDSSolution $folder | Where-Object {$_.FullName}
    Select-CDSSolution $solutionsInFolder 
}