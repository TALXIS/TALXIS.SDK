function Select-CDSEnvironment {
    param (
        [parameter(Mandatory = $false, Position = 1)]
        [string]$Name
    )
    $cdsEnvironment = $null
    $cdsEnvironmentList = Get-AdminPowerAppEnvironment

    if ($Name) {
        $cdsEnvironment = $cdsEnvironmentList | where EnvironmentName -EQ $Name
        if ($null -eq $cdsEnvironment) {
            $cdsEnvironment = $cdsEnvironmentList | where DisplayName -like *$Name*
        }
    }
    else {
        Write-Host "No environment selected from parameters, listing environments..."
    
        Write-Host "0. [Create New Environment] `n"
        for ($a = 0; $a -lt $cdsEnvironmentList.Length; $a++) {
            Write-Host "$($a + 1): $($cdsEnvironmentList[$a].DisplayName) ($($cdsEnvironmentList[$a].EnvironmentName))"
        }
    
        do {
            try {
                $selectOk = $true
                [int]$value = Read-host "Please select an environment"
            }
            catch {
                $selectOk = $false
            }
        } until (($value -ge 0 -and $value -lt $cdsEnvironmentList.Length + 1) -and $selectOK)
    
        if ($value -ne 0) {
            $cdsEnvironment = $cdsEnvironmentList[$value - 1]
        }
    }

    return $cdsEnvironment
}

