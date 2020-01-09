function Start-PackageImportScenario {
    Write-host "   _______       _     __   _______  _____ "
    Write-host "  |__   __|/\   | |    \ \ / /_   _|/ ____|"
    Write-host "     | |  /  \  | |     \ V /  | | | (___  "
    Write-host "     | | / /\ \ | |      > <   | |  \___ \ "
    Write-host "     | |/ ____ \| |____ / . \ _| |_ ____) |"
    Write-host "     |_/_/    \_\______/_/ \_\_____|_____/"
    
    write-host "`n"
    write-host "`n"
    
    Write-host "Welcome to a scenario of Package import."
    write-host "`n"
    write-host "`n"
    Write-host "We will start with your personal development environment seletion."
    Start-Sleep -Second 3
    write-host "`n"
    Write-host "Please sign in with your work account."
    Start-Sleep -Second 1
    Set-aadaccount
    write-host "`n"
    write-host "`n"
    Write-host "Welcome $($global:currentSession.upn)!"
    Start-Sleep -Second 1
    write-host "`n"
    $env = Get-CurrentBranchEnvironment
    write-host "Great! We have the environment ready ..."
    Start-Sleep -Second 3
    write-host "`n"
    Write-host "Now we need to get a package from your solution. We will be looking at your current directory."
    Start-Sleep -Second 2
    write-host "`n"
    write-host "`n"
    $packageName = List-FolderCDSPackage -folderPath ".\" | Select -First 1
    write-host "DEBUG $packageName"

    $importConfigPath = Get-ChildItem -Path $folderPath -Filter ".\src\CDSPackages\$packageName\PkgFolder\ImportConfig.xml"
    write-host "`n"
    write-host "`n"
    Import-CDSPackage -ImportConfigPath $importConfigPath.FullName -BuildFolderPath ".\build"

}