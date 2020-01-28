function Get-AzureManagementAPIToken {
    [CmdletBinding()]
    param
    (
        [string] $Audience = "https://management.azure.com/",
        [string] $ClientId = "1950a258-227b-4e31-a9cf-717495945fc2",
        [string] $RedirectUri = "urn:ietf:wg:oauth:2.0:oob",
        [string] $CertificateThumbprint
    )
    return Get-AADToken -Audience $Audience -ClientId $ClientId -RedirectUri $RedirectUri -CertificateThumbprint $CertificateThumbprint
}