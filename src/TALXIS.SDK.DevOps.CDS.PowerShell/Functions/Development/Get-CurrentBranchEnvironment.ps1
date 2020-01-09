function Get-CurrentBranchEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False,Position=1,ValueFromPipeline=$True)]
        [string]$Repository = ".\"
    )

    $environmentFriendlyName = Get-CurrentGitBranch $Repository

    if($null -eq $environmentFriendlyName)
    {
        write-host "Branch not found"
    }
    else {
        write-host "You are working in $environmentFriendlyName branch"
        
        $env = Select-CDSEnvironment -Name $environmentFriendlyName

        if($null -eq $env)
        {
            write-host "No envrionment with name $environmentFriendlyName has been found"
            $env = Create-CDSEnvironment -Name $environmentFriendlyName
        }
    }
    return $env
}