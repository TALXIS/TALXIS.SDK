function Get-PowerAppsServiceToken {
    $Audience = "https://service.powerapps.com/"
    return Get-AADToken -Audience $Audience
}