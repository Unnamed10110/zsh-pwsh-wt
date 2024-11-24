pwsh -command "& {Get-WmiObject -Query 'SELECT * FROM SoftwareLicensingService' | Select-Object OA3xOriginalProductKey, LicenseStatus, Description, @{Name='WindowsVersion';Expression={(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ProductName}}}"
pause

