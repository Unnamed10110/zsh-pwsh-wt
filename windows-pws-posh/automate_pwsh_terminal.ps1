# Relaunch script with admin rights in pwsh if not already elevated
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process "pwsh" -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# === Install PowerShell Core ===
winget install --id Microsoft.Powershell --source winget --accept-package-agreements --accept-source-agreements

# Wait briefly for install to settle
Start-Sleep -Seconds 5

# === Install Chocolatey ===
Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# === Install Windows Terminal ===
winget install --id Microsoft.WindowsTerminal --source winget --accept-package-agreements

# === Download and apply profile ===
$profileUrl = "https://raw.githubusercontent.com/Unnamed10110/zsh-pwsh-wt/master/windows-pws-posh/Microsoft.PowerShell_profile.ps1"
Invoke-WebRequest -Uri $profileUrl -OutFile $PROFILE -UseBasicParsing

# === Install Terminal Icons ===
Install-Module Terminal-Icons -Force -Scope CurrentUser
. $PROFILE

# === Install and Register Font ===
$fontUrl = "https://github.com/Unnamed10110/appsFiles_repo/raw/master/CascadiaCode-2407.24/otf/static/CascadiaCodeNF-SemiLight.otf"
$fontPath = "$env:TEMP\CascadiaCodeNF-SemiLight.otf"
Invoke-WebRequest -Uri $fontUrl -OutFile $fontPath
Copy-Item $fontPath -Destination "$env:WINDIR\Fonts\" -Force

# Register font
$ShellApp = New-Object -ComObject Shell.Application
$ShellApp.Namespace(0x14).CopyHere($fontPath)

# === Update Windows Terminal Settings ===
$wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (-Not (Test-Path $wtSettings)) {
    Write-Error "❌ Windows Terminal settings.json not found. Open Windows Terminal at least once."
    exit
}

$json = Get-Content $wtSettings -Raw | ConvertFrom-Json

# Update all profiles' font face
foreach ($profile in $json.profiles.list) {
    if (-not $profile.font) {
        $profile | Add-Member -MemberType NoteProperty -Name font -Value @{ face = "Cascadia Code NF SemiLight" }
    } else {
        $profile.font.face = "Cascadia Code NF SemiLight"
    }
}

# Ensure PowerShell Core is set as default profile
$pwshProfile = $json.profiles.list | Where-Object { $_.commandline -match "pwsh.exe" }
if (-not $pwshProfile) {
    $pwshPath = "$env:ProgramFiles\PowerShell\7\pwsh.exe"
    if (-not (Test-Path $pwshPath)) {
        Write-Error "❌ PowerShell Core not found at $pwshPath"
        exit
    }
    $guid = [guid]::NewGuid().ToString()
    $pwshProfile = [pscustomobject]@{
        guid = $guid
        name = "PowerShell"
        commandline = $pwshPath
        hidden = $false
        font = @{ face = "Cascadia Code NF SemiLight" }
    }
    $json.profiles.list += $pwshProfile
}

$json.defaultProfile = $pwshProfile.guid
$json | ConvertTo-Json -Depth 5 | Set-Content -Path $wtSettings -Encoding utf8

Write-Host "✅ PowerShell Core installed and set as default in Windows Terminal."
