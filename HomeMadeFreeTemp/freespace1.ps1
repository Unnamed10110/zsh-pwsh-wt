
#pwsh -command  "pwsh -command "
Set-PSDebug -Off

rm -Path "~\AppData\Local\temp\*" -Recurse -Force

Add-Type -AssemblyName System.Windows.Forms | Out-Null

[System.Windows.Forms.MessageBox]::Show("Unused temporary files deleted!")
Write-Host -ForegroundColor Cyan "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

Write-Host -ForegroundColor Green "rm -Path ~\AppData\Local\temp\* -Recurse -Force"

Write-Host -ForegroundColor Cyan "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

Pause
#"
#"
