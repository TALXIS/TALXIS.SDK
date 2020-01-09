function Prompt-TextOptions {
    param (
        [string[]] $OptionsArray
    )

    $selectedOption = $null

    if ($Name) {
        $selectedOption = $OptionsArray | where EnvironmentName -EQ $Name
        if ($null -eq $selectedOption) {
            $selectedOption = $OptionsArray | where DisplayName -like *$Name*
        }
    }
    else {
        Write-Host "No environment selected from parameters, listing environments..."
    
        Write-Host "0. [Create New Environment] `n"
        for ($a = 0; $a -lt $OptionsArray.Length; $a++) {
            Write-Host "$($a + 1): $($OptionsArray[$a].DisplayName) ($($OptionsArray[$a].EnvironmentName))"
        }
    
        do {
            try {
                $selectOk = $true
                [int]$value = Read-host "Please select an environment"
            }
            catch {
                $selectOk = $false
            }
        } until (($value -ge 0 -and $value -lt $OptionsArray.Length + 1) -and $selectOK)
    
        if ($value -ne 0) {
            $selectedOption = $OptionsArray[$value - 1]
        }
    }

    return $selectedOption
    
}