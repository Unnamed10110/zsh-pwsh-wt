(@(& 'C:/Users/troja/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe' init pwsh --config='C:\Users\troja\AppData\Local\Programs\oh-my-posh\themes\ys.omp.json' --print) -join "`n") | Invoke-Expression
Import-Module Terminal-Icons
set-psreadlineoption -predictionviewstyle listview
set-alias py python
set-alias cc cls
Set-PSReadLineOption –HistoryNoDuplicates:$True

function hist { 
  $find = $args; 
  Write-Host "Finding in full history using {`$_ -like `"*$find*`"}"; 
  Get-Content (Get-PSReadlineOption).HistorySavePath | ? {$_ -like "*$find*"} | Get-Unique | more 
}


#Get-Content "C:/Users/$($env:username)/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt" | Select-Object -Unique | ForEach-Object {$_} | Set-Content "C:/Users/$($env:username)/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt"
cls