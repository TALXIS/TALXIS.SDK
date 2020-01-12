function Start-PackageImportScenario {
    Start-WelcomeScenario
    
    Write-host "Welcome to a scenario of PACKAGE IMPORT."
    Write-host "This will help you to go through the process of setting up your own evironment to play around."
    write-host "`n"
    write-host "__________________________________________________________________"
    write-host "`n"
    Write-host "We will start with your personal development environment selection."
    Start-Sleep -Second 3
    write-host "`n"
    Write-host "Please sign in with your work account."
    Start-Sleep -Second 1
    Set-AADAccount
    write-host "`n"
    write-host "`n"
    Write-host "Welcome $($global:currentSession.upn)!"
    Start-Sleep -Second 1
    write-host "`n"
    $env = Get-CurrentBranchEnvironment
    write-host "Great! We've got the environment ready ..."
    Start-Sleep -Second 3
    write-host "`n"
    Write-host "Now we need to get a package from your solution. We will be looking at your current directory."
    Start-Sleep -Second 2
    write-host "`n"
    write-host "`n"
    $packageName = List-FolderCDSPackage -folderPath ".\" | Select -First 1
    write-host "DEBUG $packageName"

    $importConfigPath = Get-ChildItem -Path $folderPath -Filter "src\CDSPackages\$packageName\PkgFolder\ImportConfig.xml"
    write-host "`n"
    write-host "`n"

    $StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch 
    Import-CDSPackage -ImportConfigPath $importConfigPath.FullName -BuildFolderPath ".\build" -EnvId $env.EnvironmentName
    write-host "`n"
    write-host "`n"
    $StopWatch.Stop()
    write-host "Elapsed time $($StopWatch.Elapsed.ToString())"
}