Set-ItemProperty -Path "HKCU:\Keyboard Layout\Toggle" -Name "Hotkey" -Value "1"
Write-Host ('...F12 key binded to action toggle Keyboard layout...') -ForegroundColor Green
pause