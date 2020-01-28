function Get-BapAPIToken {
    [CmdletBinding()]
    param
    (
        [string] $Audience = "https://api.bap.microsoft.com/",
        [string] $ClientId,
        [string] $RedirectUri,
        [string] $CertificateThumbprint
    )
    return Get-AADToken -Audience $Audience -ClientId $ClientId -RedirectUri $RedirectUri -CertificateThumbprint $CertificateThumbprint
}