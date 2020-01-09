function Get-AzureManagementAPIToken {
    $Audience = "https://management.azure.com/"
    $ClientId = "1950a258-227b-4e31-a9cf-717495945fc2"
    $RedirectUri = "urn:ietf:wg:oauth:2.0:oob"
    return Get-AADToken -Audience $Audience -ClientId $ClientId -RedirectUri $RedirectUri
}