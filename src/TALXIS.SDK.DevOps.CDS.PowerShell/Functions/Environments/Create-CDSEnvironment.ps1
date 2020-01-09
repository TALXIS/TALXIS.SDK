function Create-CDSEnvironment {
    param (
        [parameter(Mandatory=$true, Position=1)]
        [string]
        $Name,

        [string]
        [ValidateSet("unitedstates","europe","asia","australia","india","japan","canada","unitedkingdom","unitedstatesfirstrelease","southamerica")]
        $LocationName = "europe",
        
        # It is not possible to create a Sandbox env with this version of SDK
        [ValidateSet("Trial","Production", "Sandbox")]
        [string]
        $EnvironmentSku = "Sandbox",

        [string]
        $CurrencyName = "USD",

        [string]
        $LanguageName = "1033",

        [string[]]
        $Templates = $null
    )

    try {
        # create new environment
        Write-Host "Creating new environment $($Name)..."
        $newEnvironment = New-AdminPowerAppEnvironmentOverride -DisplayName $Name -LocationName $LocationName -EnvironmentSku $EnvironmentSku
    
        # create database for new environment
        Write-Host "Creating database for $($newEnvironment.DisplayName)..."
        $newEnvironmentDb = New-AdminPowerAppCdsDatabase -EnvironmentName $newEnvironment.EnvironmentName -CurrencyName $CurrencyName -LanguageName $LanguageName -Templates $Templates
        Write-Host "Environment Creation:$($newEnvironment.DisplayName) - Completed"
    }
    catch {
        Write-Warning "Unabled to create new environment: $($_.Exception.Message)"
        Return
    }
    
    
    $domainName = $newEnvironmentDb.DisplayName.Substring($newEnvironmentDb.DisplayName.IndexOf("(")+1).Trim(")")
    
    $environmentId = $newEnvironmentDb.EnvironmentName


    # ensure CDS is provisioned
    do {
        Write-Host "Waiting for CDS database provisioning"
        Start-Sleep -Seconds 4
        $env = Get-AdminPowerAppEnvironment -EnvironmentName $environmentId
        Write-Host "Provisioning state: $($env.CommonDataServiceDatabaseProvisioningState)"    
    } While (-not ($env.CommonDataServiceDatabaseProvisioningState -eq "Succeeded"))

    
    Write-Host "SUCCESS - $($domainName) is provisioned"
}


function New-AdminPowerAppEnvironmentOverride
{

    [CmdletBinding(DefaultParameterSetName="User")]
    param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Name")]
        [string]$DisplayName,

        [Parameter(Mandatory = $true, ParameterSetName = "Name", ValueFromPipelineByPropertyName = $true)]
        [string]$LocationName,

        [ValidateSet("Trial", "Production", "Sandbox")]
        [Parameter(Mandatory = $true, ParameterSetName = "Name")]
        [string]$EnvironmentSku,

        [Parameter(Mandatory = $false)]
        [Switch]$ProvisionDatabase,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$CurrencyName,
    
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$LanguageName,

        [Parameter(Mandatory = $false)]
        [string[]]$Templates,

        [Parameter(Mandatory = $false)]
        [string]$SecurityGroupId = $null,

        [Parameter(Mandatory = $false)]
        [string]$DomainName = $null,

        [Parameter(Mandatory = $false)]
        [bool]$WaitUntilFinished = $true,

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = "2019-05-01"
    )
    process
    {
        $postEnvironmentUri = "https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/environments`?api-version={apiVersion}&id=/providers/Microsoft.BusinessAppPlatform/scopes/admin/environments";

        $environment = @{
            location = $LocationName
            properties = @{
                displayName = $DisplayName
                environmentSku = $EnvironmentSku
            }
        }

        if ($ProvisionDatabase)
        {
            if ($CurrencyName -ne $null -and
                $LanguageName -ne $null)
            {
                $environment.properties["linkedEnvironmentMetadata"] = @{
                    baseLanguage = $LanguageName
                    currency = @{
                        code = $CurrencyName
                    }
                    templates = $Templates
                }

                if (-not [string]::IsNullOrEmpty($SecurityGroupId))
                {
				    $environment.properties["linkedEnvironmentMetadata"] += @{
                       securityGroupId = $SecurityGroupId
                    }
                }

                if (-not [string]::IsNullOrEmpty($DomainName))
                {
                    $environment.properties["linkedEnvironmentMetadata"] += @{
                        domainName = $DomainName
                    }
                }

                $environment.properties["databaseType"] = "CommonDataService"
            }
            else
            {
                Write-Error "CurrencyName and Language must be passed as arguments."
                throw
            }

            # By default we poll until the CDS database is finished provisioning
            If($WaitUntilFinished)
            {
                $response = InvokeApiNoParseContent -Method POST -Route $postEnvironmentUri -Body $environment -ApiVersion $ApiVersion -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent -eq $true)
                $statusUrl = $response.Headers['Location']

                if ($response.StatusCode -eq "BadRequest")
                {
                    #Write-Error "An error occured."
                }
                else
                {
                    $currentTime = Get-Date -format HH:mm:ss
                    $nextTime = Get-Date -format HH:mm:ss
                    $TimeDiff = New-TimeSpan $currentTime $nextTime
                    $timeoutInSeconds = 600
        
                    #Wait until the environment has been deleted, there is an error, or we hit a timeout
                    while((-not [string]::IsNullOrEmpty($statusUrl)) -and ($response.StatusCode -ne 200) -and ($response.StatusCode -ne 404) -and ($response.StatusCode -ne 500) -and ($TimeDiff.TotalSeconds -lt $timeoutInSeconds))
                    {
                        Start-Sleep -s 5
                        $response = InvokeApiNoParseContent -Route $statusUrl -Method GET -ApiVersion $ApiVersion -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent -eq $true)
                        $nextTime = Get-Date -format HH:mm:ss
                        $TimeDiff = New-TimeSpan $currentTime $nextTime
                    }
                }

                CreateHttpResponse($response)
            }
            # optionally the caller can choose to NOT wait until provisioning is complete and get the provisioning status by polling on Get-AdminPowerAppEnvironment and looking at the provisioning status field
            else
            {
                $response = InvokeApi -Method POST -Route $route -Body $environment -ApiVersion $ApiVersion -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent -eq $true)

                if ($response.StatusCode -eq "BadRequest")
                {
                    #Write-Error "An error occured."
                    CreateHttpResponse($response)
                }

                CreateHttpResponse($response)
            }
        }
        else
        {
            $response = InvokeApi -Method POST -Route $postEnvironmentUri -ApiVersion $ApiVersion -Body $environment  -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent -eq $true)

            if ($response.StatusCode -eq "BadRequest")
            {
                #Write-Error "An error occured."
                CreateHttpResponse($response)
            }
            else
            {
                CreateEnvironmentObject -EnvObject $response -ReturnCdsDatabaseType $false
            }
        }
    }
}

function CreateHttpResponse
{
    param
    (
        [Parameter(Mandatory = $true)]
        [object]$ResponseObject
    )

    return New-Object -TypeName PSObject `
        | Add-Member -PassThru -MemberType NoteProperty -Name Code -Value $ResponseObject.StatusCode `
        | Add-Member -PassThru -MemberType NoteProperty -Name Description -Value $ResponseObject.StatusDescription `
        | Add-Member -PassThru -MemberType NoteProperty -Name Headers -Value $ResponseObject.Headers `
        | Add-Member -PassThru -MemberType NoteProperty -Name Error -Value $ResponseObject.error `
        | Add-Member -PassThru -MemberType NoteProperty -Name Errors -Value $ResponseObject.errors `
        | Add-Member -PassThru -MemberType NoteProperty -Name Internal -value $ResponseObject;
}

function CreateEnvironmentObject
{
    param
    (
        [Parameter(Mandatory = $true)]
        [object]$EnvObject,

        [Parameter(Mandatory = $false)]
        [bool]$ReturnCdsDatabaseType
    )

    If($ReturnCdsDatabaseType)
    {
        $cdsDatabaseType = "None"

        # this property will be set if the environment has linked CDS 2.0 database
        $LinkedCdsTwoInstanceType = $EnvObject.properties.linkedEnvironmentMetadata.type;

        if($LinkedCdsTwoInstanceType -eq "Dynamics365Instance")
        {
            $cdsDatabaseType = "Common Data Service for Apps"
        }
        else
        {
            #unfortunately there is no other way to determine if an environment has a database other than making a separate REST API call
            $cdsOneDatabase = Get-CdsOneDatabase -ApiVersion $ApiVersion -EnvironmentName $EnvObject.name

            if ($cdsOneDatabase.EnvironmentName -eq $EnvObject.name)
            {
                $cdsDatabaseType = "Common Data Service (Previous Version)"
            }       
        }
    }
    else {
        $cdsDatabaseType = "Unknown"
    }

    

    return New-Object -TypeName PSObject `
        | Add-Member -PassThru -MemberType NoteProperty -Name EnvironmentName -Value $EnvObject.name `
        | Add-Member -PassThru -MemberType NoteProperty -Name DisplayName -Value $EnvObject.properties.displayName `
        | Add-Member -PassThru -MemberType NoteProperty -Name IsDefault -Value $EnvObject.properties.isDefault `
        | Add-Member -PassThru -MemberType NoteProperty -Name Location -Value $EnvObject.location `
        | Add-Member -PassThru -MemberType NoteProperty -Name CreatedTime -Value $EnvObject.properties.createdTime `
        | Add-Member -PassThru -MemberType NoteProperty -Name CreatedBy -value $EnvObject.properties.createdBy `
        | Add-Member -PassThru -MemberType NoteProperty -Name LastModifiedTime -Value $EnvObject.properties.lastModifiedTime `
        | Add-Member -PassThru -MemberType NoteProperty -Name LastModifiedBy -value $EnvObject.properties.lastModifiedBy.userPrincipalName `
        | Add-Member -PassThru -MemberType NoteProperty -Name CreationType -value $EnvObject.properties.creationType `
        | Add-Member -PassThru -MemberType NoteProperty -Name EnvironmentType -value $EnvObject.properties.environmentSku `
        | Add-Member -PassThru -MemberType NoteProperty -Name CommonDataServiceDatabaseProvisioningState -Value $EnvObject.properties.provisioningState `
        | Add-Member -PassThru -MemberType NoteProperty -Name CommonDataServiceDatabaseType -Value $cdsDatabaseType `
        | Add-Member -PassThru -MemberType NoteProperty -Name Internal -value $EnvObject `
        | Add-Member -PassThru -MemberType NoteProperty -Name InternalCds -value $cdsOneDatabase;
}