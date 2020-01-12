function Install-XRMSDK {
    param (
        # location of the current script running
        [string]$ScriptLocation = ".\",
        # location of the tools folder on the machine
        [string]$ToolsFolder = ".\"
    )

    $coreToolsFolder = "$ToolsFolder\Microsoft.CrmSdk.CoreTools"
    $pluginRegistrationToolFolder = "$ToolsFolder\Microsoft.CrmSdk.XrmTooling.PluginRegistrationTool"
    $configurationMigrationFolder = "$ToolsFolder\Microsoft.CrmSdk.XrmTooling.ConfigurationMigration"
    $packageDeployerFolder = "$ToolsFolder\Microsoft.CrmSdk.XrmTooling.PackageDeployment"
    $xrmToolboxFolder = "$ToolsFolder\XrmToolbox"
    $webApiFolder = "$ToolsFolder\Microsoft.Xrm.WebApi.PowerShell"

    ##
    ##Download CoreTools
    ##
    if (Test-Path $coreToolsFolder -PathType Container) {
        Write-Host "Skipping CoreTools since it's already installed."
    }
    else {
        Get-NuGetClient
        nuget install Microsoft.CrmSdk.CoreTools -O $ToolsFolder
        mkdir $coreToolsFolder
        $ctFolder = Get-ChildItem $ToolsFolder | Where-Object { $_.Name -match 'Microsoft.CrmSdk.CoreTools.' }
        Move-Item $ToolsFolder\$ctFolder\content\bin\coretools\*.* $coreToolsFolder
        Remove-Item $ToolsFolder\$ctFolder -Force -Recurse
    }

    ##
    ##Download Plugin Registration Tool
    ##
    if (Test-Path $pluginRegistrationToolFolder -PathType Container) {
        Write-Host "Skipping Plugin Registration Tool since it's already installed."
    }
    else {
        Get-NuGetClient
        nuget install Microsoft.CrmSdk.XrmTooling.PluginRegistrationTool -O $ToolsFolder
        mkdir $pluginRegistrationToolFolder
        $prtFolder = Get-ChildItem $ToolsFolder | Where-Object { $_.Name -match 'Microsoft.CrmSdk.XrmTooling.PluginRegistrationTool.' }
        Move-Item $ToolsFolder\$prtFolder\tools\*.* $pluginRegistrationToolFolder
        Remove-Item $ToolsFolder\$prtFolder -Force -Recurse
    }

    ##
    ##Download Configuration Migration
    ##
    if (Test-Path $configurationMigrationFolder -PathType Container) {
        Write-Host "Skipping Configuration Migration since it's already installed."
    }
    else {
        Get-NuGetClient
        nuget install Microsoft.CrmSdk.XrmTooling.ConfigurationMigration.Wpf -O $ToolsFolder
        mkdir $configurationMigrationFolder
        $configMigFolder = Get-ChildItem $ToolsFolder | Where-Object { $_.Name -match 'Microsoft.CrmSdk.XrmTooling.ConfigurationMigration.Wpf.' }
        Move-Item $ToolsFolder\$configMigFolder\tools\*.* $configurationMigrationFolder
        Remove-Item $ToolsFolder\$configMigFolder -Force -Recurse
    }

    ##
    ##Download Package Deployer 
    ##
    if (Test-Path $packageDeployerFolder -PathType Container) {
        Write-Host "Skipping Package Deployer since it's already installed."
    }
    else {
        Get-NuGetClient
        nuget install Microsoft.CrmSdk.XrmTooling.PackageDeployment.WPF -O $ToolsFolder
        mkdir $packageDeployerFolder
        $pdFolder = Get-ChildItem $ToolsFolder | Where-Object { $_.Name -match 'Microsoft.CrmSdk.XrmTooling.PackageDeployment.Wpf.' }
        Move-Item $ToolsFolder\$pdFolder\tools\*.* $packageDeployerFolder
        Remove-Item $ToolsFolder\$pdFolder -Force -Recurse
    }


    ##
    ##Download XrmToolbox
    ##
    if (Test-Path $xrmToolboxFolder -PathType Container) {
        Write-Host "Skipping XrmToolbox it's already installed."
    }
    else {
        $xrmToolboxLatestRelease = "https://github.com/MscrmTools/XrmToolBox/releases/latest/download/XrmToolbox.zip"
        $xrmToolboxZip = "$($ToolsFolder)\xrmtoolbox.zip"
        Invoke-WebRequest $xrmToolboxLatestRelease -OutFile $xrmToolboxZip
        Expand-Archive $xrmToolboxZip -DestinationPath $xrmToolboxFolder
        Remove-Item $xrmToolboxZip
    }

    ##
    ##Install Microsoft.Xrm.WebApi.PowerShell
    ##
    if (Test-Path $webApiFolder -PathType Container) {
        Write-Host "Skipping Microsoft.Xrm.WebApi.PowerShell it's already installed."
    }
    else {
        Install-EmbeddedModules -ModuleName "Microsoft.Xrm.WebApi.PowerShell" -ModulesFolder $ToolsFolder
    }
    Import-Module $webApiFolder -Global

}

