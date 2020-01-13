function Start-DevEnvSetupScenario {
    Start-Sleep -Second 1
    write-host "`n"
    $global:currentEnvironment = Get-CurrentBranchEnvironment
}