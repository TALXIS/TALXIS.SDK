function Connect-CDSInstance {
    $global:cdsConnection = Get-CrmConnection -InteractiveMode -Verbose
}
