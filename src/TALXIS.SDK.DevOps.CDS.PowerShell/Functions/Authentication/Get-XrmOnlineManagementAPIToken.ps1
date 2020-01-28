function Get-XrmOnlineManagementAPIToken {
    [CmdletBinding()]
    param
    (
        [string] $Audience,
        [string] $ClientId,
        [string] $RedirectUri,
        [string] $CertificateThumbprint
    )
    if ([string]::IsNullOrEmpty($Audience) -eq $false) {
        $Audience = "https://admin.services.crm4.dynamics.com"
    }
    if ([string]::IsNullOrEmpty($ClientId) -eq $false) {
        $ClientId = "2ad88395-b77d-4561-9441-d0e40824f9bc"
    }
    if ([string]::IsNullOrEmpty($RedirectUri) -eq $false) {
        $RedirectUri = "app://5d3e90d6-aa8e-48a8-8f2c-58b45cc67315"
    }
    return Get-AADToken -Audience $Audience -ClientId $ClientId -RedirectUri $RedirectUri -CertificateThumbprint $CertificateThumbprint
}