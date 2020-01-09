function Set-AADAccount {
    $global:currentSession = $null;
    Get-AzureManagementAPIToken | out-null
    Get-XrmOnlineManagementAPIToken | out-null
    Get-BapAPIToken | out-null
    Get-PowerAppsServiceToken | out-null
}