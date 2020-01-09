function Export-CDSSolution{
   
        [CmdletBinding()]
        PARAM(
            [parameter(Mandatory=$true, Position=1)]
            [string]$SolutionName,
            [parameter(Mandatory=$false, Position=2)]
            [switch]$Managed
        )    
    
        Verify-CDSConnection

        write-host "Exporting solution: $SolutionName"
		$request = New-Object Microsoft.Crm.Sdk.Messages.ExportSolutionRequest
		$request.Managed = $Managed
		$request.SolutionName = $SolutionName
		$response = $cdsConnection.Execute($request)
		if(!$Managed)
		{
		  [io.file]::WriteAllBytes("$workingDirPath\$SolutionName.zip",$response.ExportSolutionFile)
		}
		else{
		  [io.file]::WriteAllBytes("$workingDirPath\${SolutionName}_managed.zip",$response.ExportSolutionFile)
		}
}



