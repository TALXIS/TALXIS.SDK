function Verify-CDSConnection {
    $connobj = Get-Variable cdsConnection -Scope global -ErrorAction SilentlyContinue
    if($connobj.Value -eq $null)
    {
        Connect-CDSInstance
    }
    else
    {
        $conn = $connobj.Value
    }

}