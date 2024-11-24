# Script Header
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Green
Write-Host "                  WINDOWS AND HARDWARE INFORMATION" -ForegroundColor Cyan
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Green

# Windows Licensing Information
Write-Host "`n[Windows Licensing Information]" -ForegroundColor Cyan
$licenseInfo = Get-WmiObject -Query 'SELECT * FROM SoftwareLicensingService' | 
    Select-Object OA3xOriginalProductKey, LicenseStatus, Description, @{Name='WindowsVersion';Expression={(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ProductName}}
Write-Host "OA3xOriginalProductKey: " -ForegroundColor Yellow -NoNewline; Write-Host $licenseInfo.OA3xOriginalProductKey -ForegroundColor White
Write-Host "LicenseStatus: " -ForegroundColor Yellow -NoNewline; Write-Host $licenseInfo.LicenseStatus -ForegroundColor White
Write-Host "Description: " -ForegroundColor Yellow -NoNewline; Write-Host $licenseInfo.Description -ForegroundColor White
Write-Host "WindowsVersion: " -ForegroundColor Yellow -NoNewline; Write-Host $licenseInfo.WindowsVersion -ForegroundColor White

# License Channel Information
Write-Host "`n[License Channel]" -ForegroundColor Cyan
$licenseChannel = (Get-WmiObject -Class SoftwareLicensingService).OA3xOriginalProductKey
if ($licenseChannel) {
    Write-Host "The operating system license is OEM." -ForegroundColor White
} else {
    Write-Host "The operating system license is Retail or Volume License." -ForegroundColor White
}
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Green

# Computer Hardware Info
Write-Host "`n[Computer Hardware Info]" -ForegroundColor Cyan
$computerInfo = Get-WmiObject -Class Win32_ComputerSystem | 
    Select-Object Manufacturer, Model, Name, SystemType
Write-Host "Manufacturer: " -ForegroundColor Yellow -NoNewline; Write-Host $computerInfo.Manufacturer -ForegroundColor White
Write-Host "Model: " -ForegroundColor Yellow -NoNewline; Write-Host $computerInfo.Model -ForegroundColor White
Write-Host "Name: " -ForegroundColor Yellow -NoNewline; Write-Host $computerInfo.Name -ForegroundColor White
Write-Host "SystemType: " -ForegroundColor Yellow -NoNewline; Write-Host $computerInfo.SystemType -ForegroundColor White

# BIOS Info
Write-Host "`n[BIOS Info]" -ForegroundColor Cyan
$biosInfo = Get-WmiObject -Class Win32_BIOS | 
    Select-Object SerialNumber, BIOSVersion, Manufacturer, ReleaseDate
Write-Host "SerialNumber: " -ForegroundColor Yellow -NoNewline; Write-Host $biosInfo.SerialNumber -ForegroundColor White
Write-Host "BIOSVersion: " -ForegroundColor Yellow -NoNewline; Write-Host $biosInfo.BIOSVersion -ForegroundColor White
Write-Host "Manufacturer: " -ForegroundColor Yellow -NoNewline; Write-Host $biosInfo.Manufacturer -ForegroundColor White
Write-Host "ReleaseDate: " -ForegroundColor Yellow -NoNewline; Write-Host $biosInfo.ReleaseDate -ForegroundColor White

# Operating System Info
Write-Host "`n[Operating System Info]" -ForegroundColor Cyan
$osInfo = Get-WmiObject -Class Win32_OperatingSystem | 
    Select-Object Caption, OSArchitecture, Version, LastBootUpTime
Write-Host "Caption: " -ForegroundColor Yellow -NoNewline; Write-Host $osInfo.Caption -ForegroundColor White
Write-Host "OSArchitecture: " -ForegroundColor Yellow -NoNewline; Write-Host $osInfo.OSArchitecture -ForegroundColor White
Write-Host "Version: " -ForegroundColor Yellow -NoNewline; Write-Host $osInfo.Version -ForegroundColor White
Write-Host "LastBootUpTime: " -ForegroundColor Yellow -NoNewline; Write-Host $osInfo.LastBootUpTime -ForegroundColor White

# Installed Applications
Write-Host "`n[Installed Applications]" -ForegroundColor Cyan
$installedApps = Get-WmiObject -Class Win32_Product |
    Select-Object Name, Version, Vendor, InstallDate, InstallLocation

# Use a counter to number the programs
$counter = 1
$installedApps | ForEach-Object {
    # Get the size of the installation folder if available
    $programSize = 0
    if ($_.InstallLocation) {
        try {
            $programSize = (Get-ChildItem -Path $_.InstallLocation -Recurse -File | Measure-Object -Sum Length).Sum
        } catch {
            $programSize = 0
        }
    }
    
    # Convert size from bytes to a more readable format (MB)
    $programSizeMB = [math]::round($programSize / 1MB, 2)

    Write-Host "$counter. Name: " -ForegroundColor Yellow -NoNewline; Write-Host "$($_.Name)" -ForegroundColor White
    Write-Host "   Version: " -ForegroundColor Yellow -NoNewline; Write-Host "$($_.Version)" -ForegroundColor White
    Write-Host "   Vendor: " -ForegroundColor Yellow -NoNewline; Write-Host "$($_.Vendor)" -ForegroundColor White
    Write-Host "   Install Date: " -ForegroundColor Yellow -NoNewline; Write-Host "$($_.InstallDate)" -ForegroundColor White
    #Write-Host "   Size: " -ForegroundColor Yellow -NoNewline; Write-Host "$programSizeMB MB" -ForegroundColor White
    Write-Host "------------------------------" -ForegroundColor Gray
    $counter++
}

# Network Adapter Configuration
Write-Host "`n[Network Adapter Configuration]" -ForegroundColor Cyan
$networkAdapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | 
    Select-Object Description, MACAddress, IPAddress
$networkAdapters | ForEach-Object {
    Write-Host "Description: " -ForegroundColor Yellow -NoNewline; Write-Host $_.Description -ForegroundColor White
    Write-Host "MACAddress: " -ForegroundColor Yellow -NoNewline; Write-Host $_.MACAddress -ForegroundColor White
    Write-Host "IPAddress: " -ForegroundColor Yellow -NoNewline; Write-Host ($_."IPAddress" -join ', ') -ForegroundColor White
    Write-Host "------------------------------" -ForegroundColor Gray
}

# Disk Drives Info
Write-Host "`n[Disk Drives Info]" -ForegroundColor Cyan
$diskDrives = Get-WmiObject -Class Win32_DiskDrive | 
    Select-Object Model, InterfaceType, MediaType, Size
Write-Host "Model: " -ForegroundColor Yellow -NoNewline; Write-Host $diskDrives.Model -ForegroundColor White
Write-Host "InterfaceType: " -ForegroundColor Yellow -NoNewline; Write-Host $diskDrives.InterfaceType -ForegroundColor White
Write-Host "MediaType: " -ForegroundColor Yellow -NoNewline; Write-Host $diskDrives.MediaType -ForegroundColor White
Write-Host "Size: " -ForegroundColor Yellow -NoNewline; Write-Host $diskDrives.Size -ForegroundColor White

# Footer
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Green
Write-Host "                  INFORMATION COLLECTION COMPLETED" -ForegroundColor Cyan
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Green

# Pause to keep console open
pause
