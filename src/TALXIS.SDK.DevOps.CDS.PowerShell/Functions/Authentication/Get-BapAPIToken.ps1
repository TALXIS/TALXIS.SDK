function Get-BapAPIToken {
    $Audience = "https://api.bap.microsoft.com/"
    return Get-AADToken -Audience $Audience
}