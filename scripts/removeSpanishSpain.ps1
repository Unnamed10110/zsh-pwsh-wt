# Reset Taskbar settings to default
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowImeIcon" -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Software\Microsoft\CTF" -Recurse -Force -ErrorAction SilentlyContinue

# Restart Explorer to apply changes
Stop-Process -Name explorer -Force
Start-Process explorer

Write-Output "Taskbar settings have been reset. Check for the language/keyboard layout icon."
