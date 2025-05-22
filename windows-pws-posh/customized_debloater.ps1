# create restore point
# Must be run as administrator
$restorePointName = "Manual Restore Point"
$descriptionType = 0  # 0 = APPLICATION_INSTALL, 1 = APPLICATION_UNINSTALL, 10 = DEVICE_DRIVER_INSTALL, 12 = MODIFY_SETTINGS

# Create the restore point
$sysRestore = Get-CimInstance -Namespace "root/default" -ClassName SystemRestore
$result = Invoke-CimMethod -InputObject $sysRestore -MethodName CreateRestorePoint -Arguments @{
    Description = $restorePointName
    RestorePointType = $descriptionType
    EventType = 100  # BEGIN_SYSTEM_CHANGE
}

# Check result
if ($result.ReturnValue -eq 0) {
    Write-Host "Restore point created successfully."
} elseif ($result.ReturnValue -eq 1) {
    Write-Warning "Restore point creation throttled. Try again later."
} else {
    Write-Error "Failed to create restore point. Error code: $($result.ReturnValue)"
}
Write-Host "`n✅ Press any key to continue...."


# Must be run as admin
$appsToRemove = @(
    "Microsoft.549981C3F5F10",               # Cortana
    "Microsoft.WindowsFeedbackHub",         # Feedback Hub
    "Microsoft.GetHelp",                    # Get Help
    "Microsoft.Getstarted",                 # Get Started / Tips
    "Microsoft.ZuneVideo",                  # Movies & TV
    "Microsoft.People",                     # People
    "Microsoft.ScreenSketch",              # Snipping Tool
    "Microsoft.MicrosoftSolitaireCollection", # Solitaire
    "Microsoft.BingWeather",                # Weather
    "Microsoft.XboxGamingOverlay",          # Xbox Game Bar
    "Microsoft.XboxApp",                    # Xbox App
    "Microsoft.XboxIdentityProvider",       # Xbox Identity Provider
    "Microsoft.YourPhone",                  # Phone Link
    "Microsoft.OneDrive"                    # OneDrive
)

# Remove from current user
foreach ($app in $appsToRemove) {
    Write-Host "Removing $app for current user..."
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
}

# Remove provisioned packages (preinstalled for new users)
foreach ($app in $appsToRemove) {
    Write-Host "Removing provisioned $app for new users..."
    Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like "*$app*" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# Special removal: OneDrive (System-level)
Write-Host "Uninstalling OneDrive..."
Start-Process "C:\Windows\System32\OneDriveSetup.exe" "/uninstall" -NoNewWindow -Wait -ErrorAction SilentlyContinue

Write-Host "`n✅ App removal complete. Some changes may require a reboot."

Stop-Process -Name "StartMenuExperienceHost" -Force -ErrorAction SilentlyContinue


Write-Host "`n✅ Press any key to continue...."

# --- DISABLE CONSUMER FEATURES ---
Write-Host "Disabling Consumer Experience (app suggestions)..."
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableConsumerFeatures" -PropertyType DWord -Value 1 -Force

# --- DISABLE WINDOWS RECALL (if present) ---
Write-Host "Disabling Windows Recall (if supported)..."
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" -Name "DisableAIDataCapture" -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue

# --- DISABLE INTERNET EXPLORER ---
Write-Host "Removing Internet Explorer..."
Disable-WindowsOptionalFeature -FeatureName "Internet-Explorer-Optional-amd64" -Online -NoRestart -ErrorAction SilentlyContinue

# --- REMOVE FAX AND SCAN ---
Write-Host "Removing Windows Fax and Scan..."
Disable-WindowsOptionalFeature -FeatureName "FaxServicesClientPackage" -Online -NoRestart -ErrorAction SilentlyContinue

# --- REMOVE WIDGETS (App and Taskbar) ---
Write-Host "Uninstalling Widgets app (Windows Web Experience Pack)..."
Get-AppxPackage -Name "MicrosoftWindows.Client.WebExperience" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue

Write-Host "Removing Widgets taskbar icon via registry..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -PropertyType DWord -Value 0 -Force

# --- OPTIONAL: Apply to all new users (default user hive) ---
Write-Host "Disabling Widgets for all new users (default profile)..."
$defaultUserHive = "C:\Users\Default\NTUSER.DAT"
reg load HKU\TempDefault "$defaultUserHive"
reg add "HKU\TempDefault\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
reg unload HKU\TempDefault

Write-Host "`n✅ All specified features disabled or removed. Restart recommended."

Write-Host "`n✅ Press any key to continue...."
Pause


# ----------------------------
# 🪪 WINDOWS TELEMETRY
# ----------------------------

Write-Host "Disabling Windows Telemetry..."

# Basic telemetry block
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "MaxTelemetryAllowed" -PropertyType DWord -Value 0 -Force

# Disable feedback prompts
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "PeriodInDays" -PropertyType DWord -Value 0 -Force

# Disable Windows Search Telemetry
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCloudSearch" -PropertyType DWord -Value 0 -Force

# Disable Application Experience
Disable-ScheduledTask -TaskName "ProgramDataUpdater" -TaskPath "\Microsoft\Windows\Application Experience\" -ErrorAction SilentlyContinue

# Disable Handwriting Data Collection
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" -Name "PreventHandwritingErrorReports" -PropertyType DWord -Value 1 -Force

# Disable Clipboard cloud sync
New-ItemProperty -Path "HKCU:\Software\Microsoft\Clipboard" -Name "EnableCloudClipboard" -PropertyType DWord -Value 0 -Force

# Disable Tailored Experiences (targeted ads)
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -PropertyType DWord -Value 0 -Force

# Opt out of consent prompts
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowDeviceNameInTelemetry" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" -Name "DisablePrivacyExperience" -PropertyType DWord -Value 1 -Force

# Disable Windows Update telemetry
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" -TaskName "SendUpdateNotification" -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" -TaskName "Scheduled Start" -ErrorAction SilentlyContinue

# ----------------------------
# 🎯 THIRD-PARTY TELEMETRY
# ----------------------------

Write-Host "Disabling third-party telemetry..."

# 🎨 Adobe: block outgoing connections
New-NetFirewallRule -DisplayName "Block Adobe Telemetry" -Direction Outbound -Program "C:\Program Files (x86)\Adobe\*" -Action Block -Profile Any -Enabled True

# ✂️ Disable Adobe Acrobat auto-updater
reg add "HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" /v bUpdater /t REG_DWORD /d 0 /f

# 🎮 Disable NVIDIA telemetry
Stop-Service -Name NvTelemetryContainer -ErrorAction SilentlyContinue
Set-Service -Name NvTelemetryContainer -StartupType Disabled -ErrorAction SilentlyContinue

# ⚙️ VS Code: disable telemetry
$vsCodeSettings = "$env:APPDATA\Code\User\settings.json"
if (Test-Path $vsCodeSettings) {
    (Get-Content $vsCodeSettings -Raw) | ConvertFrom-Json | ForEach-Object {
        $_["telemetry.enableTelemetry"] = $false
        $_["telemetry.enableCrashReporter"] = $false
        $_
    } | ConvertTo-Json -Depth 10 | Set-Content $vsCodeSettings -Encoding UTF8
}

# 🎵 Media Player (Groove/Movies): disable telemetry
New-ItemProperty -Path "HKCU:\Software\Microsoft\Zune\Telemetry" -Name "TelemetryDisabled" -PropertyType DWord -Value 1 -Force

# 🖥️ PowerShell 7: disable telemetry
$profileFile = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if (!(Test-Path $profileFile)) { New-Item -ItemType File -Path $profileFile -Force }
Add-Content -Path $profileFile -Value '$env:POWERSHELL_TELEMETRY_OPTOUT = "1"'

# 🧹 CCleaner: disable telemetry and background monitoring
reg add "HKCU\Software\Piriform\CCleaner" /v Monitoring /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v SystemMonitoring /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v UpdateAuto /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v AnalyticsEnabled /t REG_DWORD /d 0 /f
Stop-Process -Name CCleaner* -Force -ErrorAction SilentlyContinue

# ----------------------------
# 🧹 FINAL CLEANUP
# ----------------------------

Write-Host "`n✅ All telemetry-related features disabled. A restart is recommended."
Write-Host "`n✅ Press any key to continue...."
Pause

# ----------------------------
# 🎮 DISABLE GAME MODE
# ----------------------------
Write-Host "Disabling Game Mode..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "UseGameMode" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "GameModeEnabled" -PropertyType DWord -Value 0 -Force

# ----------------------------
# 🎮 DISABLE GAME BAR
# ----------------------------
Write-Host "Disabling Xbox Game Bar..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "ShowStartupPanel" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "GamePanelStartupTipIndex" -PropertyType DWord -Value 3 -Force

# Disable Game DVR
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AllowGameDVR" -PropertyType DWord -Value 0 -Force

# ----------------------------
# 🖱 DISABLE MOUSE ACCELERATION
# ----------------------------
Write-Host "Disabling Mouse Acceleration..."
$mouseRegPath = "HKCU:\Control Panel\Mouse"
Set-ItemProperty -Path $mouseRegPath -Name "MouseSpeed" -Value "0"
Set-ItemProperty -Path $mouseRegPath -Name "MouseThreshold1" -Value "0"
Set-ItemProperty -Path $mouseRegPath -Name "MouseThreshold2" -Value "0"

# ----------------------------
# 🪟 DISABLE FULLSCREEN OPTIMIZATIONS
# ----------------------------
Write-Host "Disabling Fullscreen Optimizations globally (via compatibility shim)..."
# This does NOT disable FSO globally by default. It must be done per-executable. Here's how to apply a global override (hacky):
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "DisallowFullScreenOptimizations=1;" /f

# Optional: Disable for a specific game/app (example)
# $appPath = "C:\Games\MyGame.exe"
# reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "$appPath" /t REG_SZ /d "DisallowFullScreenOptimizations=1;" /f

Write-Host "`n✅ Gaming tweaks applied. Some may require a restart or logoff to fully apply."
Write-Host "`n✅ Press any key to continue...."
Pause

# Must be run as Administrator
function Set-ServicesToManual {
    param (
        [string[]]$ServiceNames
    )

    foreach ($svc in $ServiceNames) {
        Write-Host "Setting '$svc' to Manual startup..."
        try {
            Set-Service -Name $svc -StartupType Manual -ErrorAction Stop
        } catch {
            Write-Warning "Could not configure $svc (may not exist or access denied)"
        }
    }
}

# 🧾 Non-Essential Services (safe to set to Manual on most systems)
$servicesToSetManual = @(
    "Fax",                        # Windows Fax
    "RetailDemo",                 # Retail demo service
    "DiagTrack",                  # Telemetry
    "MapsBroker",                 # Offline maps
    "WMPNetworkSvc",              # Windows Media Player Network Sharing
    "WerSvc",                     # Windows Error Reporting
    "DoSvc",                      # Delivery Optimization
    "PcaSvc",                     # Program Compatibility Assistant
    "RemoteRegistry",             # Rarely needed, security risk
    "WSearch",                    # Windows Search (optional; slows SSD indexing)
    "XblAuthManager",             # Xbox Live Auth
    "XblGameSave",                # Xbox Live Game Save
    "XboxNetApiSvc",             # Xbox networking
    "dmwappushservice",           # Push Notification service
    "SysMain",                    # Superfetch (performance degradation on SSDs)
    "PhoneSvc",                   # Phone Link
    "OneSyncSvc",                 # Calendar/Mail/People sync
    "CDPUserSvc*",                # Connected Devices Platform
    "WbioSrvc",                   # Biometric Service (if no fingerprint scanner)
    "SEMgrSvc",                   # Payments and NFC/Wallet
    "SensorService",              # Sensors (GPS/light sensor etc)
    "TabletInputService",         # Touch keyboard/ink (for non-touch devices)
    "WdiServiceHost",             # Diagnostic System Host
    "WdiSystemHost",              # Diagnostic System
    "StorSvc",                    # Storage Service (set to manual if not using Storage Spaces)
    "AppVClient",                 # Microsoft App-V Client (virtual apps)
    "HvHost",                     # Hyper-V host compute service (if Hyper-V not used)
    "lfsvc",                      # Geolocation Service
    "SharedAccess",              # Internet Connection Sharing
    "TrkWks",                     # Distributed Link Tracking Client
    "icssvc"                      # Internet Connection Sharing (ICS)
)

Set-ServicesToManual -ServiceNames $servicesToSetManual

Write-Host "`n✅ Non-essential services set to manual. Restart recommended."
Write-Host "`n✅ Press any key to continue...."
Pause
# Must be run as Administrator
Write-Host "Limiting Microsoft Defender CPU usage to 20%..."

Set-MpPreference -ScanAvgCPULoadFactor 20

Write-Host "✅ Defender CPU usage limited to 20%."
Write-Host "`n✅ Press any key to continue...."
Pause


# Must be run as Administrator
Write-Host "Stopping and disabling Windows Search service..."

# Stop and disable the service
Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
Set-Service -Name "WSearch" -StartupType Disabled

# Disable indexing on all fixed drives (C:, D:, etc.)
Write-Host "Disabling indexing on all fixed drives..."

$drives = Get-PSDrive -PSProvider 'FileSystem' | Where-Object { $_.Free -gt 0 -and $_.Root -match "^[A-Z]:\\$" }
foreach ($drive in $drives) {
    $vol = $drive.Root.TrimEnd('\')
    Write-Host "Disabling indexing on $vol..."
    try {
        # Remove index attribute
        attrib -I "$vol\*" /S /D
        # Use COM object to update properties
        $objShell = New-Object -ComObject Shell.Application
        $objFolder = $objShell.NameSpace($vol)
        $objFolder.Items() | ForEach-Object { $_.Attributes = $_.Attributes -bor 0x2000 }
    } catch {
        Write-Warning "Failed to disable indexing on $vol"
    }
}

Write-Host "`n✅ Drive indexing disabled."
Write-Host "`n✅ Press any key to continue...."
Pause


# Must be run as Administrator

Write-Host "🔧 Applying Windows customizations..."

# --- 🖱️ Restore Classic Right-Click Menu (Windows 11 only)
Write-Host "Restoring classic right-click context menu..."
New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Force | Out-Null
New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(Default)" -Value "" -Force

# --- 🛑 Add "End Task" to context menu (Windows 11 22H2+)
Write-Host "Adding 'End Task' to context menu..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarEndTask" -PropertyType DWord -Value 1 -Force

# --- 📌 Move taskbar icons to the left
Write-Host "Aligning taskbar icons to the left..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -PropertyType DWord -Value 0 -Force

# --- 🔢 Disable NumLock on startup
Write-Host "Disabling NumLock at boot..."
Set-ItemProperty -Path "HKU\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Value "0"

# --- 🌑 Enable dark mode
Write-Host "Enabling dark mode..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0

# --- 📄 Show file extensions
Write-Host "Showing file extensions..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# --- 👁 Show all hidden and system files
Write-Host "Showing hidden and system files..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1

# --- ❌ Disable Sticky Keys prompt
Write-Host "Disabling Sticky Keys prompt..."
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value "506"
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "Flags" -Value "122"
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" -Name "Flags" -Value "58"

# --- 💥 Enable detailed BSOD
Write-Host "Enabling detailed BSOD..."
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\CrashControl" -Name "DisplayParameters" -Value 1

# --- 🔍 Enable verbose logon messages
Write-Host "Enabling verbose logon/logoff messages..."
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -PropertyType DWord -Value 1 -Force

# --- 🛑 Disable automatic restart on BSOD
Write-Host "Disabling automatic restart on crash..."
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\CrashControl" -Name "AutoReboot" -Value 0


# Run as Administrator

powercfg /hibernate on

Write-Host "Hibernation enabled."


# Run as Administrator

Write-Host "Setting lid close action to Hibernate (plugged in and on battery)..."

# GUIDs for power settings
$subGroupLid = "4f971e89-eebd-4455-a8de-9e59040e7347"  # Lid close action subgroup
$settingLidClose = "5ca83367-6e45-459f-a27b-476b1d01c936" # Lid close action setting

# Possible values:
# 0 = Do nothing
# 1 = Sleep
# 2 = Hibernate
# 3 = Shut down

# Set action to Hibernate (2) for both AC and DC power
powercfg /setacvalueindex SCHEME_CURRENT $subGroupLid $settingLidClose 2
powercfg /setdcvalueindex SCHEME_CURRENT $subGroupLid $settingLidClose 2

# Apply the changes
powercfg /SETACTIVE SCHEME_CURRENT

Write-Host "Done. Lid close action set to Hibernate."


Write-Host "`n✅ All tweaks applied. Some changes may require log off or reboot to take full effect."

Write-Host "`n✅ Press any key to continue...."
Pause