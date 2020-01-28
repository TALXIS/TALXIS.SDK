function Get-XrmOnlineManagementAPIToken {
    [CmdletBinding()]
    param
    (
        [string] $Audience = "https://admin.services.crm4.dynamics.com",
        [string] $ClientId = "2ad88395-b77d-4561-9441-d0e40824f9bc",
        [string] $RedirectUri = "app://5d3e90d6-aa8e-48a8-8f2c-58b45cc67315",
        [string] $CertificateThumbprint
    )
    return Get-AADToken -Audience $Audience -ClientId $ClientId -RedirectUri $RedirectUri -CertificateThumbprint $CertificateThumbprint
}