function Get-AADToken {
    [CmdletBinding()]
    param
    (
        [string] $Audience = "https://management.azure.com/",
        [string] $ClientId = "1950a258-227b-4e31-a9cf-717495945fc2",
        [string] $RedirectUri = "urn:ietf:wg:oauth:2.0:oob"
    )

    $authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext("https://login.windows.net/common");
    $authParameters = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters -ArgumentList ([Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::SelectAccount);


    if ($null -eq $global:currentSession) {
        $global:currentSession = @{
            loggedIn = $false;
        };
    }

    if ($global:currentSession.loggedIn -eq $false -or $global:currentSession.expiresOn -lt (Get-Date)) {
        Write-Host "No user logged in. Signing the user in before acquiring token."
        
        $authResult = $authContext.AcquireTokenAsync($Audience, $ClientId, $RedirectUri, $authParameters).GetAwaiter().GetResult();

        $claims = Get-TokenClaims -JwtToken $authResult.IdToken

        #This variable and it's structure is the same as in Microsoft.PowerApps.Administration.PowerShell to keep compatibility
        $global:currentSession = @{
            loggedIn            = $true;
            idToken             = $authResult.IdToken;
            upn                 = $claims.upn;
            tenantId            = $claims.tid;
            userId              = $claims.oid;
            expiresOn           = (Get-Date).AddHours(8);
            resourceTokens      = @{
                $Audience = @{
                    accessToken = $authResult.AccessToken;
                    expiresOn   = $authResult.ExpiresOn;
                }
            };
            selectedEnvironment = "~default";
            flowEndpoint        = "api.flow.microsoft.com";
            powerAppsEndpoint   = "api.powerapps.com";
            bapEndpoint         = "api.bap.microsoft.com";
            graphEndpoint       = "graph.windows.net";
            cdsOneEndpoint      = "api.cds.microsoft.com";
        };

    }

    if ($global:currentSession.resourceTokens[$Audience] -eq $null -or `
            $global:currentSession.resourceTokens[$Audience].accessToken -eq $null -or `
            $global:currentSession.resourceTokens[$Audience].expiresOn -eq $null -or `
            $global:currentSession.resourceTokens[$Audience].expiresOn -lt (Get-Date)) {

        Write-Verbose "Token for $Audience is either missing or expired. Acquiring a new one."
        
        $authParameters = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters -ArgumentList ([Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Auto);
        $authResult = $authContext.AcquireTokenAsync($Audience, $ClientId, $RedirectUri, $authParameters).GetAwaiter().GetResult();

        
        $global:currentSession.resourceTokens[$Audience] = @{
            accessToken = $authResult.AccessToken;
            expiresOn   = $authResult.ExpiresOn;
        }
    }

    return $global:currentSession.resourceTokens[$Audience].accessToken;
}