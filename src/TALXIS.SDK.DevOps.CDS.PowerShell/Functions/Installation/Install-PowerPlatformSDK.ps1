function Install-PowerPlatformSDK {
    $global:powerPlatformSdkPath = Path.Combine($workingDirPath, "PowerPlatformSDK");
    New-Item $powerPlatformSdkPath -ItemType Directory -Force | Out-Null
    Write-host "tools folder: $powerPlatformSdkPath"

    Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
    Install-PowerShellModule -RootPath $powerPlatformSdkPath -ModuleName "Microsoft.Xrm.OnlineManagementAPI"
    Install-PowerShellModule -RootPath $powerPlatformSdkPath -ModuleName "Microsoft.Xrm.Tooling.CrmConnector.PowerShell"
    Install-PowerShellModule -RootPath $powerPlatformSdkPath -ModuleName "Microsoft.Xrm.Tooling.PackageDeployment.Powershell"
    Install-PowerShellModule -RootPath $powerPlatformSdkPath -ModuleName "Microsoft.PowerApps.Checker.PowerShell"
    Install-PowerShellModule -RootPath $powerPlatformSdkPath -ModuleName "Microsoft.PowerApps.Administration.PowerShell"

    Install-XRMSDK -ToolsFolder $powerPlatformSdkPath
}
