pwsh -command "& {Get-WmiObject -Query 'SELECT * FROM SoftwareLicensingService' | Select-Object OA3xOriginalProductKey, LicenseStatus, Description, @{Name='WindowsVersion';Expression={(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ProductName}}}"

Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Green
Write-Host "Availabe HW info." -ForegroundColor Green

    # Get the Windows activation and version info
    $licenseInfo = Get-WmiObject -Query 'SELECT * FROM SoftwareLicensingService' | Select-Object OA3xOriginalProductKey, LicenseStatus, Description, @{Name='WindowsVersion';Expression={(Get-ItemProperty -Path ''HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'').ProductName}}

    # Get hardware information
    $computerInfo = Get-WmiObject -Class Win32_ComputerSystem | Select-Object Manufacturer, Model, Name, SystemType
    $biosInfo = Get-WmiObject -Class Win32_BIOS | Select-Object SerialNumber

    # Display the information
    Write-Output 'Windows Activation and Version Info:'
    $licenseInfo | Format-List

    Write-Output 'Computer Hardware Info:'
    $computerInfo | Format-List

    Write-Output 'BIOS Info:'
    $biosInfo | Format-List

    pause
