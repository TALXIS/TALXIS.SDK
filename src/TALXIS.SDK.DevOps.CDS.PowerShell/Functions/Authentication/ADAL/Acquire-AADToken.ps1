function Acquire-AADToken {
    [CmdletBinding()]
    param
    (
        [string] $Audience,
        [string] $ClientId,
        [string] $RedirectUri,
        [string] $CertificateThumbprint,
        [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior] $PromptBehavior,
        $tokenCache
    )

    $authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext("https://login.windows.net/common", $tokenCache);

    if ([string]::IsNullOrEmpty($CertificateThumbprint) -eq $false) {
        $certAssertion = Get-AADCertificateAssertion -CertificateThumbprint $CertificateThumbprint -ClientId $ClientId
        return $authContext.AcquireTokenAsync($Audience, $certAssertion).GetAwaiter().GetResult();
    }
    else {
        $authParameters = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters -ArgumentList ($PromptBehavior);
        return $authContext.AcquireTokenAsync($Audience, $ClientId, $RedirectUri, $authParameters).GetAwaiter().GetResult();
    }
}