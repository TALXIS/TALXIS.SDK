function Get-PowerAppsServiceToken {
    [CmdletBinding()]
    param
    (
        [string] $Audience = "https://service.powerapps.com/",
        [string] $ClientId,
        [string] $RedirectUri,
        [string] $CertificateThumbprint
    )
    return Get-AADToken -Audience $Audience -ClientId $ClientId -RedirectUri $RedirectUri -CertificateThumbprint $CertificateThumbprint
}