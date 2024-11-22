Get-Content "C:/Users/$($env:username)/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt" | Select-Object -Unique | ForEach-Object {$_} | Set-Content "C:/Users/$($env:username)/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt"


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("Command History File Cleaned!")

Read-Host -Prompt "Press Enter to continue"