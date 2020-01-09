function Reset-CDSEnvironment {
    param (
        [parameter(Mandatory=$false, Position=1)]
        [string]$Name
    )

    $env = (Select-CDSEnvironment $Name)
    $envName = $env.EnvironmentName
    $domainName = $env.DisplayName.Substring($env.DisplayName.IndexOf("(")+1).Trim(")")
    $friendlyName = $env.DisplayName.Substring(0, $env.DisplayName.IndexOf("(")-1)
    Remove-CDSEnvironment $envName
    Create-CDSEnvironment -Name $friendlyName -LocationName $env.Location
} 




#API IMPLEMENTATION - DOES NOT WORK PROPERLY AS OF NOW

<# $serviceUrl = "https://admin.services.crm4.dynamics.com"
$environmentId = "62abf906-c9e5-4b17-bd3e-6407a55597e9"
$resetUrl = "$serviceUrl/api/v1.3/Instances/$environmentId/Reset"

$token = Get-XrmOnlineManagementAPIToken
$header = @{Authorization='Bearer ' + $token}

$body = @{
    "DomainName"="org86f48966"
    "FriendlyName"="resetpokus"
    "SecurityGroupId"=$null
    "BaseLanguageCode"=1033
    "Currency"=@{
        "Code"="USD"
        "Name"="USD"
        "Precision"=2
        "Symbol"="US$"
    }
    #"ApplicationNames"=@()
} | ConvertTo-Json

#SAMPLES: "applicationNames":["D365_Sales","D365_CustomerService","D365_FieldService","D365_ProjectServiceAutomation"],

$result = (Invoke-WebRequest -Uri $resetUrl -Headers $header -Body $body -ContentType "application/json" -Method POST)
 #>