function Invoke-SolutionPackager {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][ValidateSet("Extract", "Pack")] $action,
        [parameter(Mandatory = $true)] $zipFile,
        [parameter(Mandatory = $true)] $folder,
        [parameter(Mandatory = $true)][ValidateSet("Unmanaged", "Managed", "Both")] $packagetype,
        [parameter(Mandatory = $false)][ValidateSet("Yes", "No")] $allowDelete,
        [parameter(Mandatory = $false)][ValidateSet("Yes", "No")] $allowWrite,
        [parameter(Mandatory = $false)][bool] $clobber,
        [parameter(Mandatory = $false)][ValidateSet("Off", "Error", "Warning", "Info", "Verbose")] $errorLevel,
        [parameter(Mandatory = $false)] $map,
        [parameter(Mandatory = $false)] $log
    )

    begin {
        $solutionPackagerNugetPackage = "Microsoft.CrmSdk.CoreTools"

        $nugetPackageRootPath = [System.IO.Path]::Combine($powerAppsToolsPath, $solutionPackagerNugetPackage)

        $solutionPackagerFilePath = Get-ChildItem $nugetPackageRootPath -Recurse -Filter "SolutionPackager.exe"

        if ($solutionPackagerFilePath) {
            $soPaExe = $solutionPackagerFilePath.FullName
            Write-Verbose "SolutionPackager.exe found: $soPaExe"
            #Create custom object with required parameters.
            $packParms = $PSBoundParameters
        }
        else {
            Write-Error "Could not locate SolutionPackager.exe in path: $nugetPackageRootPath"
        }
    }

    process {
        ForEach ($property in $packParms.GetEnumerator()) {
            if ($property.key -eq "clobber") {
                $soPaArgList += ("/" + $property.key + " ")
            }
            else {
                $soPaArgList += ("/" + $property.key + ":" + $property.value + " ")
            }
        }

        Write-Host "##[command]""$soPaExe"" $soPaArgList"
        Invoke-Expression "& '$soPaExe' --% $soPaArgList" | Write-Host
        Write-Verbose "Exit code: $LASTEXITCODE"

        if ($LASTEXITCODE -ne 0)
        {
            Write-Error "SolutionPackager failed: $LASTEXITCODE"
        }
    }

    end {
        return $LASTEXITCODE
    }
}