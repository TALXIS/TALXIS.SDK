function Open-CDSEnvironment {
    param (
        [string]$Name
    )
    $env = Select-CDSEnvironment -Name $Name
    #Default browser Start-Process "https://make.powerapps.com/environments/$($env.EnvironmentName)/solutions"
    Start-Process chrome.exe -ArgumentList @( '-incognito', "https://make.powerapps.com/environments/$($env.EnvironmentName)/solutions" )
}