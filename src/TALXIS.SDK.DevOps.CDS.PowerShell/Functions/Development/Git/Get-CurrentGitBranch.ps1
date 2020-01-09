function Get-CurrentGitBranch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False,Position=1,ValueFromPipeline=$True)]
        [string]$Repository = ".\"
    )

    get-gitbranch $Repository | where-object {$_.Current -eq $true} | Select-Object -ExpandProperty Name
}