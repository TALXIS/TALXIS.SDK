function Get-NuGetClient {
    <# TODO: locate the executable in 'C:\Program Files\PackageManagement\ProviderAssemblies' or 
    'C:\Users\tomasprokop\AppData\Local\PackageManagement\ProviderAssemblies'. or
    %localappdata%\PackageManagement\ProviderAssemblies #>
    
    if(!(Test-Path alias:nuget)) {
        Write-Host "Downloading NuGet.exe"
        $sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
        $targetNugetExe = [System.IO.Path]::Combine($workingDirPath, "nuget.exe")
        Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
        Set-Alias nuget $targetNugetExe -Scope Global -Verbose
    }
}