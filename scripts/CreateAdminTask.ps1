# Define the registry path for AutoPlay settings
$AutoPlayRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers"

# Get the current value of DisableAutoplay
$disableAutoplay = Get-ItemProperty -Path $AutoPlayRegistryPath -Name "DisableAutoplay" -ErrorAction SilentlyContinue

if ($disableAutoplay.DisableAutoplay -eq 1) {
    # If AutoPlay is currently disabled, enable it
    Set-ItemProperty -Path $AutoPlayRegistryPath -Name "DisableAutoplay" -Value 0
    Set-ItemProperty -Path $AutoPlayRegistryPath -Name "NoDriveTypeAutoRun" -Value 0x91
    Write-Output "AutoPlay has been enabled. Drives will now open automatically when connected."
} else {
    # If AutoPlay is currently enabled, disable it
    Set-ItemProperty -Path $AutoPlayRegistryPath -Name "DisableAutoplay" -Value 1
    Set-ItemProperty -Path $AutoPlayRegistryPath -Name "NoDriveTypeAutoRun" -Value 0xFF
    Write-Output "AutoPlay has been disabled. Drives will no longer open automatically when connected."
}
pause