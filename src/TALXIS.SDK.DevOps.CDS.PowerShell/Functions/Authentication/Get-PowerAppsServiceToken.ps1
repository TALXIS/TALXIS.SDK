function Get-PowerAppsServiceToken {
    [CmdletBinding()]
    param
    (
        [string] $Audience,
        [string] $ClientId,
        [string] $RedirectUri,
        [string] $CertificateThumbprint
    )
    if ([string]::IsNullOrEmpty($Audience) -eq $false) {
        $Audience = "https://service.powerapps.com/"
    }
    return Get-AADToken -Audience $Audience -ClientId $ClientId -RedirectUri $RedirectUri -CertificateThumbprint $CertificateThumbprint
}