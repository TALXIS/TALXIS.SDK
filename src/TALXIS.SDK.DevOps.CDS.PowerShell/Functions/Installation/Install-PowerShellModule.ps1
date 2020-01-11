function Install-PowerShellModule {
    [CmdletBinding()]
    param(
        [string][ValidateNotNullOrEmpty()]$RootPath,
        [string][ValidateNotNullOrEmpty()]$ModuleName,
        [string][ValidateNotNullOrEmpty()]$ModuleVersion
    )

    Write-Host "Installing PS module $ModuleName ..."
    $savedModulePath = [IO.Path]::Combine($RootPath, $ModuleName)

    if (!(Test-Path -Path $savedModulePath)) {
        Save-Module -Name $ModuleName -Path $RootPath

        Get-ChildItem "$savedModulePath\*\*" -file | move-item -Destination {$_.Directory.Parent.Fullname} -Force
    } else {
        Write-Host "Found module already installed, nothing to do."
    }
    Import-Module $savedModulePath -Global
}