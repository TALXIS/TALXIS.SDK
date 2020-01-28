function Connect-CDSInstance {

    #Certificate:
    #Url=https://abc.crm4.dynamics.com; AppId=guid; CertificateThumbprint=hex; CertificateStoreName="My"; AuthType=Certificate; RedirectUri=https://dev.azure.com/thenetworg; LoginPrompt=Never;SkipDiscovery=true;
    
    #ADAL Cache
    #"AuthType=OAuth;Username=;Password=;Url=https://abc.crm4.dynamics.com;AppId={AppId};RedirectUri={RedirectUrl};" + "TokenCacheStorePath=" + DefaultTokenCachePath + ";RequireNewInstance=true;LoginPrompt=Auto

    $global:cdsConnection = Get-CrmConnection -InteractiveMode -Verbose
}
