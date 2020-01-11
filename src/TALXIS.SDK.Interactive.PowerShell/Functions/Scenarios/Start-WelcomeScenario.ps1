function Start-WelcomeScenario {
    $Host.UI.RawUI.BackgroundColor = ($bckgrnd = 'White')
    $Host.UI.RawUI.ForegroundColor = 'DarkBlue'
    write-host "`n"
    write-host "`n"
    Write-host "   _______       _     __   _______  _____ " 
    Write-host "  |__   __|/\   | |    \ \ / /_   _|/ ____|"
    Write-host "     | |  /  \  | |     \ V /  | | | (___  "
    Write-host "     | | / /\ \ | |      > <   | |  \___ \ "
    Write-host "     | |/ ____ \| |____ / . \ _| |_ ____) |"
    Write-host "     |_/_/    \_\______/_/ \_\_____|_____/"
    write-host "`n"
    write-host "`n"
}