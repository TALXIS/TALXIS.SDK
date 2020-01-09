function Remove-CDSEnvironment {
    param (
        [parameter(Mandatory=$true, Position=1)]
        [string]
        $Name
    )
    
    $envName = (Select-CDSEnvironment $Name).EnvironmentName
    
    $removeEnvironmentResult = Remove-AdminPowerAppEnvironment -EnvironmentName $envName

    if ($removeEnvironmentResult.Code -eq 202 -and $removeEnvironmentResult.Description -eq "Accepted") {
        Write-Output "Remove environment submitted, sleeping waiting for delete..."
    } elseif ($removeEnvironmentResult.Errors) {
        Write-Warning "Environment removal error: $($removeEnvironmentResult.Internal.errors)"
        Return
    }

    # ensure the environment is removed before continuing
    do {
        Start-Sleep -Seconds 4
        $cdsEnvironmentList = Get-AdminPowerAppEnvironment
        $removeEnvironment = $cdsEnvironmentList | where EnvironmentName -EQ $envName
    } While ($removeEnvironment)

    Write-Output "Environment $Name Deleted."
}