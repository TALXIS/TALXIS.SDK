function List-FolderCDSPackage {
    param(
        [string]$folderPath
    )
    $packageList = New-Object System.Collections.ArrayList($null)

    foreach($configFile in (Get-ChildItem -Path $folderPath -Filter 'ImportConfig.xml' -Recurse))
    {
        $csprojFile = Get-ChildItem -Path $configFile.Directory.parent.FullName -Filter *.csproj | Select -First 1

        if($null -ne $csprojFile)
        {
            write-host "Found csproj $($csprojFile.BaseName)"

            [XML]$csprojContents = Get-Content $csprojFile.FullName

            $packageAssemblyName = $csprojContents.Project.PropertyGroup.AssemblyName
            write-host "Package assembly name is $packageAssemblyName.dll"
            
            [void]$packageList.Add($packageAssemblyName)
        }
    }
}