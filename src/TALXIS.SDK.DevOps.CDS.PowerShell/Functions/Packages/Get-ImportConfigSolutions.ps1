function Get-ImportConfigSolutions {
    param (
        [string] $ImportConfigPath
    )
    
    [XML]$configContents = Get-Content $ImportConfigPath

    return $configContents.configdatastorage.solutions.configsolutionfile | Select -ExpandProperty "solutionpackagefilename"
}