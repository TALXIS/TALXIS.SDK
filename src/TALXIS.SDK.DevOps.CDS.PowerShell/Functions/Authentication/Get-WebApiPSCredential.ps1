function Get-WebApiPSCredential {
    param (
        [string]$UserName = " "
    )

    return New-Object System.Management.Automation.PSCredential ($UserName, (ConvertTo-SecureString " " -AsPlainText -Force))
    
}