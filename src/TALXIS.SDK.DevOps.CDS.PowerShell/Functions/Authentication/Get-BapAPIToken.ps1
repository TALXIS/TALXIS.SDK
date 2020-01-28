function Get-BapAPIToken {
    [CmdletBinding()]
    param
    (
        [string] $Audience,
        [string] $ClientId,
        [string] $RedirectUri,
        [string] $CertificateThumbprint
    )
    if ([string]::IsNullOrEmpty($Audience) -eq $false) {
        $Audience = "https://api.bap.microsoft.com/"
    }
    return Get-AADToken -Audience $Audience -ClientId $ClientId -RedirectUri $RedirectUri -CertificateThumbprint $CertificateThumbprint
}