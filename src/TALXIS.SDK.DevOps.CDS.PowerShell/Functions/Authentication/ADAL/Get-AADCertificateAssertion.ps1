using namespace System.Security.Cryptography.X509Certificates;
function Get-AADCertificateAssertion {
    [CmdletBinding()]
    param
    (
        [string] $CertificateThumbprint,
        [string] $ClientId
    )

    #Find certificate and prepare credentials
    if ([string]::IsNullOrEmpty($CertificateThumbprint) -eq $false) {
        
        $storeName = [StoreName]::My
        $storeLocation = [StoreLocation]::CurrentUser #or LocalMachine

        $certStore = [X509Store](New-Object X509Store($storeName, $storeLocation))
        $certStore.Open([OpenFlags]::ReadOnly)
        $cert = $certStore.Certificates.Find([X509FindType]::FindByThumbprint, $CertificateThumbprint, $false)[0]
        $certStore.Close()

        return New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.ClientAssertionCertificate($ClientId, $cert);
    }
    else{
        return $null
    }
}