function Install-EmbeddedModules {
    param (
        [string]$ModuleName,
        [string]$ModulesFolder
    )
    $moduleZip = "$($MyInvocation.MyCommand.Module.ModuleBase)\Resources\$ModuleName.zip"
    Expand-Archive $moduleZip -DestinationPath $ModulesFolder\$ModuleName
    Import-Module $ModulesFolder\$ModuleName -Global    
}