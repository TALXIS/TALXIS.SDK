<# function Import-CDSSolution{
   
    [CmdletBinding()]
    PARAM(
        [parameter(Mandatory=$false, Position=1)]
        [string]$SolutionZipPath,
        [parameter(Mandatory=$false, Position=2)]
        [switch]$Stage = $false
    )    

    Verify-CDSConnection

    if(!$SolutionZipPath) {
        $SolutionZipPath = Select-LocalCDSSolution
    }

    $Managed = ($SolutionZipPath -like '*_managed*') 

    $solutionName = [System.IO.Path]::GetFileNameWithoutExtension($SolutionZipPath).Replace("_managed", "")

    write-host "Importing solution: $solutionName"
    
    $solutionZip = [System.IO.File]::ReadAllBytes($SolutionZipPath)
    $request = [Microsoft.Crm.Sdk.Messages.ImportSolutionRequest]::New()
    $request.CustomizationFile = $solutionZip
    $request.PublishWorkflows = $true
    $request.OverwriteUnmanagedCustomizations = $true
    $request.SkipProductUpdateDependencies = $false
    $request.HoldingSolution = $Stage

    $cdsConnection.Execute($request)

    if(!$Managed)
	{
        write-host "Publishing customizations"
        $publishRequest = New-Object Microsoft.Crm.Sdk.Messages.PublishAllXmlRequest
		$cdsConnection.Execute($publishRequest)
	}

    if($Stage)
	{
        write-host "Applying solution upgrade"
        $upgradeRequest = [Microsoft.Crm.Sdk.Messages.DeleteAndPromoteRequest]::New()
        $upgradeRequest.UniqueName = $solutionName
		$cdsConnection.Execute($upgradeRequest)
	}
}



 #>