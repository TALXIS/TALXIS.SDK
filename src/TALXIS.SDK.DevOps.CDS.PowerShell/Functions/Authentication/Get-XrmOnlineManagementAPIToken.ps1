function Get-XrmOnlineManagementAPIToken {
    $resourceUrl = "https://admin.services.crm4.dynamics.com"
    $clientId = "2ad88395-b77d-4561-9441-d0e40824f9bc"
    $redirectUri = "app://5d3e90d6-aa8e-48a8-8f2c-58b45cc67315"

    return Get-AADToken -Audience $resourceUrl -ClientId $clientId -RedirectUri $redirectUri
}