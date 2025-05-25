

# Must be run as Administrator
Write-Host "âš™ï¸ Enabling Hyper-V and virtualization features..."

$features = @(
    "Microsoft-Hyper-V-All",                 # Complete Hyper-V stack
    "Microsoft-Hyper-V",                     # Core Hyper-V services
    "Microsoft-Hyper-V-Management-Clients",  # Hyper-V GUI tools (optional)
    "Microsoft-Hyper-V-Management-PowerShell", # PowerShell module for Hyper-V
    "VirtualMachinePlatform",                # WSL2/VM support
    "HypervisorPlatform"                     # Hypervisor Platform APIs
)

foreach ($feature in $features) {
    Enable-WindowsOptionalFeature -Online -FeatureName $feature -All -NoRestart -ErrorAction SilentlyContinue
}

Write-Host "`nâœ… All virtualization features enabled. A reboot is required to apply changes."



Write-Host "âœ… Windows Terminal launch size and position updated successfully."

# Must be run as the user whose theme you want to change

# Convert hex color #00FF44 (RGB) to BGR (Windows format)
# RGB: 0x00 (R), 0xFF (G), 0x44 (B)
# BGR: 0x44 (B), 0xFF (G), 0x00 (R)
# So hex BGR = 0x44FF00

$accentColorBGR = 0x44FF00

# Set AccentColor
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "AccentColor" -Value $accentColorBGR -Type DWord

# Set AccentColorInactive (optional, for inactive windows)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "AccentColorInactive" -Value $accentColorBGR -Type DWord


Write-Host "Accent color set to green (#00FF44). Changes take effect after sign out/in or restart Explorer."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence" -Value 0 -Type DWord

# Restart Explorer to apply changes immediately
Stop-Process -Name explorer -Force
Start-Process explorer.exe

# Run as current user

# Enable Task View button (1 = show, 0 = hide)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 1 -Type DWord

# Restart Explorer to apply changes
Stop-Process -Name explorer -Force
Start-Process explorer.exe

Write-Host "Task View button enabled on taskbar."
Write-Host "Accent color on taskbar disabled."

# Run as current user

# Set title bar to pure black (BGR format = 0x00000000)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "ColorizationColor" -Type DWord -Value 0x00000000

# Ensure Windows uses accent color for title bars
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence" -Type DWord -Value 1

# Set theme mode to dark
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Type DWord -Value 0

# Restart Explorer to apply
Stop-Process -Name explorer -Force
Start-Process explorer.exe

Write-Host "Title bar set to pure black."


Write-Host "`nâœ… All installations and configurations completed." -ForegroundColor Green

Write-Host "`nâœ… Finished!..." -ForegroundColor Green

Pause