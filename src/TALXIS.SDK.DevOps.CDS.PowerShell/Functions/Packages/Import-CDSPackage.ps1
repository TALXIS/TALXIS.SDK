function Import-CDSPackage {
    param (
        [string]$ImportConfigPath,
        [string]$BuildFolderPath,
        [string]$EnvId
    )
    
    $env = Select-CDSEnvironment $EnvId
    $domainName = $env.DisplayName.Substring($env.DisplayName.IndexOf("(")+1).Trim(")")
    $domain = "https://$domainName.crm4.dynamics.com"

    write-host "Environment $domain has been selected"

    $solutionFileNames = Get-ImportConfigSolutions -ImportConfigPath $ImportConfigPath

    foreach($solutionFileName in $solutionFileNames)
    {
        $solutionFile = Get-ChildItem -Path $BuildFolderPath -Filter $solutionFileName -Recurse | Select -First 1

        Write-host "Importing $($solutionFile.FullName) ..."
        $cred = Get-WebApiPSCredential
        Import-Solution -ApiUrl $domain `
                        -Credential $cred -SolutionInputFile $solutionFile.FullName `
                        -HoldingSolution $false `
                        -OverwriteUnmanagedCustomizations $true `
                        -PublishWorkflows $true `
                        -SkipProductUpdateDependencies $true `
                        -AsyncOperation $false `
                        -MaxAsyncWaitTime (New-TimeSpan -Hours 1)
    }
}