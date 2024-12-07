
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8


#(@(& 'C:/Users/troja/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe' init pwsh --config='D:\repos\zsh-pwsh-wt\windows-pws-posh\half-lifeMOD.omp.json' --print) -join "`n") | Invoke-Expression

#oh-my-posh init pwsh --config 'D:\repos\zsh-pwsh-wt\windows-pws-posh\half-lifeMOD.omp.json' | Invoke-Expression

#oh-my-posh init pwsh --config 'C:\Users\troja\AppData\Local\Programs\oh-my-posh\themes\atomicBit.omp.json' | Invoke-Expression
# half-lifeMOD.omp.json   sonicboom_dark.omp.json   stelbent.minimal.omp.json  kali atomicBit
oh-my-posh init pwsh --config 'D:\repos\zsh-pwsh-wt\windows-pws-posh\kalimod.omp.json' | Invoke-Expression


Import-Module Terminal-Icons
set-psreadlineoption -predictionviewstyle listview
set-alias py python
set-alias cc cls
Set-PSReadLineOption –HistoryNoDuplicates:$True

#pwsh -NoLogo
#cmd  -NoLogo
#wsl zsh -NoLogo


#function hist { 
#  $find = $args; 
#  Write-Host "Finding in full history using {`$_ -like `"*$find*`"}"; 
#  Get-Content (Get-PSReadlineOption).HistorySavePath | ? {$_ -like "*$find*"} | Get-Unique | more 
#}



#Get-Content "C:/Users/$($env:username)/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt" | Select-Object -Unique | ForEach-Object {$_} | Set-Content "C:/Users/$($env:username)/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt"


#function prompt {
    # Print the line with the width of the terminal window
#    Write-Host ('─' * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor Green
#    Write-Host ('─' * [System.Console]::WindowWidth) -ForegroundColor Red

#}
#---------------------------------------------------------------------------
Write-Host ('...2 Seconds to check displayed errors/logs...') -ForegroundColor Green
Start-Sleep -Seconds 2
cls
Write-Host('
███████████▓▓▓▓▓▓▓▓▒░░░░░▒▒░░░░░░░▓█████
██████████▓▓▓▓▓▓▓▓▒░░░░░▒▒▒░░░░░░░░▓████
█████████▓▓▓▓▓▓▓▓▒░░░░░░▒▒▒░░░░░░░░░▓███
████████▓▓▓▓▓▓▓▓▒░░░░░░░▒▒▒░░░░░░░░░░███
███████▓▓▓▓▓▓▓▓▒░░▒▓░░░░░░░░░░░░░░░░░███
██████▓▓▓▓▓▓▓▓▒░▓████░░░░░▒▓░░░░░░░░░███
█████▓▒▓▓▓▓▓▒░▒█████▓░░░░▓██▓░░░░░░░▒███
████▓▒▓▒▒▒░░▒███████░░░░▒████░░░░░░░░███
███▓▒▒▒░░▒▓████████▒░░░░▓████▒░░░░░░▒███
██▓▒▒░░▒██████████▓░░░░░▓█████░░░░░░░███
██▓▒░░███████████▓░░░░░░▒█████▓░░░░░░███
██▓▒░▒██████████▓▒▒▒░░░░░██████▒░░░░░▓██
██▓▒░░▒███████▓▒▒▒▒▒░░░░░▓██████▓░░░░▒██
███▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░███████▓░░░▓██
███▓░░░░░▒▒▒▓▓▒▒▒▒░░░░░░░░░██████▓░░░███
████▓▒▒▒▒▓▓▓▓▓▓▒▒▓██▒░░░░░░░▓███▓░░░░███
██████████▓▓▓▓▒▒█████▓░░░░░░░░░░░░░░████
█████████▓▓▓▓▒▒░▓█▓▓██░░░░░░░░░░░░░█████
███████▓▓▓▓▓▒▒▒░░░░░░▒░░░░░░░░░░░░██████
██████▓▓▓▓▓▓▒▒░░░░░░░░░░░░░░░░▒▓████████
██████▓▓▓▓▓▒▒▒░░░░░░░░░░░░░░░▓██████████
██████▓▓▓▓▒▒██████▒░░░░░░░░░▓███████████
██████▓▓▓▒▒█████████▒░░░░░░▓████████████
██████▓▓▒▒███████████░░░░░▒█████████████
██████▓▓░████████████░░░░▒██████████████
██████▓░░████████████░░░░███████████████
██████▓░▓███████████▒░░░████████████████
██████▓░███████████▓░░░█████████████████
██████▓░███████████░░░██████████████████
██████▓▒██████████░░░███████████████████
██████▒▒█████████▒░▓████████████████████
██████░▒████████▓░██████████████████████
██████░▓████████░███████████████████████
██████░████████░▒███████████████████████
█████▓░███████▒░████████████████████████
█████▒░███████░▓████████████████████████
█████░▒██████░░█████████████████████████
█████░▒█████▓░██████████████████████████
█████░▓█████░▒██████████████████████████
█████░▓████▒░███████████████████████████
█████░▓███▓░▓███████████████████████████
██████░▓▓▒░▓████████████████████████████
███████▒░▒██████████████████████████████
████████████████████████████████████████
████████████████████████████████████████
')  -ForegroundColor black -BackgroundColor white
#Write-Host ('─' * [System.Console]::WindowWidth) -ForegroundColor Red
#Write-Host ('...I can always do it tomorrow...') -ForegroundColor Red
#Write-Host ('─' * [System.Console]::WindowWidth) -ForegroundColor Red



#{
#  "type": "command",
#  "style": "plain",
#  "foreground": "#ffffff",
#  "properties": {
#    "shell": "pwsh",
#    "command": "$cols = $Host.UI.RawUI.WindowSize.Width; Write-Host ('─' * (100 - 1)) -ForegroundColor Green"
#  },
#  "template": "{{ .Output }}"
#},

