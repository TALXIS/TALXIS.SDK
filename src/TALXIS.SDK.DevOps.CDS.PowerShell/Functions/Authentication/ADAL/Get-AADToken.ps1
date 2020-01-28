

function Get-AADToken {
    [CmdletBinding()]
    param
    (
        [string] $Audience = "https://management.azure.com/",
        [string] $ClientId = "1950a258-227b-4e31-a9cf-717495945fc2",
        [string] $RedirectUri = "urn:ietf:wg:oauth:2.0:oob",
        [string] $CertificateThumbprint
    )

       

    # Reuse TokenCache from Microsoft.Xrm.Tooling.CrmConnector with vache file path from Microsoft.Xrm.WebApi.PowerShell to prevent multiple prompts
    Add-Type -Path (Join-Path -Path $powerPlatformSdkPath -ChildPath "Microsoft.Xrm.Tooling.CrmConnector.PowerShell\Microsoft.Xrm.Tooling.Connector.dll")
    $localAppDataPath = [Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)
    $tokenCachePath = Join-Path -Path (Join-Path -Path $localAppDataPath -ChildPath "Microsoft") -ChildPath ("PowerApp.BuildTools")
    $tokenCacheType = [Microsoft.Xrm.Tooling.Connector.CrmServiceClient].Assembly.GetType("Microsoft.Xrm.Tooling.Connector.CrmServiceClientTokenCache")
    $tokenCache = $tokenCacheType.GetConstructors()[0].Invoke(@([string]$tokenCachePath))

    # Initialize current session storage
    if ($null -eq $global:currentSession) {
        $global:currentSession = @{
            loggedIn = $false;
        };
    }

    if ($global:currentSession.loggedIn -eq $false -or $global:currentSession.expiresOn -lt (Get-Date)) {
        Write-Host "No user logged in. Signing the user in before acquiring token."
        
        $authResult = Acquire-AADToken $Audience $ClientId $RedirectUri $CertificateThumbprint [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::SelectAccount $tokenCache

        $claims = Get-TokenClaims -JwtToken $authResult.IdToken

        # This variable and it's structure is the same as in Microsoft.PowerApps.Administration.PowerShell to keep compatibility with OOB CLI tools
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

    if ($null -eq $global:currentSession.resourceTokens[$Audience] -or `
            $null -eq $global:currentSession.resourceTokens[$Audience].accessToken -or `
            $null -eq $global:currentSession.resourceTokens[$Audience].expiresOn -or `
            $global:currentSession.resourceTokens[$Audience].expiresOn -lt (Get-Date)) {

        Write-Verbose "Token for $Audience is either missing or expired. Acquiring a new one."
        
        $authResult = Acquire-AADToken $Audience $ClientId $RedirectUri $CertificateThumbprint [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Auto $tokenCache
        
        $global:currentSession.resourceTokens[$Audience] = @{
            accessToken = $authResult.AccessToken;
            expiresOn   = $authResult.ExpiresOn;
        }
    }

    return $global:currentSession.resourceTokens[$Audience].accessToken;
}
