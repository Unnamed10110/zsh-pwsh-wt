# Install-Setup.ps1 - Portable PowerShell Setup Script
# Run this script with elevated privileges (as Administrator)

# --- CONFIGURATION ---
$global:ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$global:TempDir = "$env:TEMP\PortableWinSetup"
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

# --- Ensure Elevated Privileges ---
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Restarting script as Administrator..."
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# --- Ensure Chocolatey Installed ---
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# --- Ensure PowerShell Core Installed ---
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    choco install powershell-core -y
    Start-Sleep -Seconds 5
}

# Relaunch in pwsh if needed
if ($PSCommandPath -and $PSVersionTable.PSEdition -ne 'Core') {
    $pwshPath = "$env:ProgramFiles\PowerShell\7\pwsh.exe"
    if (Test-Path $pwshPath) {
        & "$pwshPath" -NoProfile -ExecutionPolicy Bypass -File "$PSCommandPath"
        exit
    }
}

# --- Utility Functions ---
function Install-ChocoPackages {
    param ([string[]]$Packages)
    choco install $Packages -y
}

function Download-And-Install {
    param (
        [string]$Url,
        [string]$OutFile,
        [switch]$Execute
    )
    Invoke-WebRequest -Uri $Url -OutFile $OutFile
    if ($Execute) { Start-Process $OutFile -Wait }
}

function Install-Font {
    param ([string]$FontUrl)
    $fontPath = Join-Path $TempDir (Split-Path $FontUrl -Leaf)
    $fontDest = "$env:WINDIR\Fonts\" + (Split-Path $FontUrl -Leaf)
    Invoke-WebRequest -Uri $FontUrl -OutFile $fontPath
    Copy-Item $fontPath -Destination $fontDest -Force
    (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere($fontPath)
}

# --- Windows Terminal and Profile ---
winget install --id Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements
Install-Module Terminal-Icons -Force -Scope CurrentUser
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Unnamed10110/zsh-pwsh-wt/master/windows-pws-posh/Microsoft.PowerShell_profile.ps1" -OutFile $PROFILE -UseBasicParsing
. $PROFILE

# --- Install Font ---
Install-Font -FontUrl "https://github.com/Unnamed10110/appsFiles_repo/blob/master/CascadiaCode-2407.24/otf/static/CascadiaCodeNF-Regular.otf"

# --- Customize Windows Terminal ---
$wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wtSettings) {
    $json = Get-Content $wtSettings -Raw | ConvertFrom-Json
    foreach ($profile in $json.profiles.list) {
        if (-not $profile.font) { $profile | Add-Member -MemberType NoteProperty -Name font -Value @{ face = "Cascadia Code NF" } }
        else { $profile.font.face = "Cascadia Code NF SemiLight" }
    }
    $pwshProfile = $json.profiles.list | Where-Object { $_.commandline -match "pwsh.exe" }
    if (-not $pwshProfile) {
        $guid = [guid]::NewGuid().ToString()
        $pwshProfile = [pscustomobject]@{
            guid = $guid
            name = "PowerShell"
            commandline = "$env:ProgramFiles\PowerShell\7\pwsh.exe"
            hidden = $false
        }
        $json.profiles.list += $pwshProfile
    }
    $json.defaultProfile = $pwshProfile.guid
    $json | ConvertTo-Json -Depth 5 | Set-Content -Path $wtSettings -Encoding UTF8
}

# --- Background Image and Style ---
$imagePath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\pillarsofcreation_0000.png"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Unnamed10110/zsh-pwsh-wt/master/pillarsofcreation_0000.png" -OutFile $imagePath
if (Test-Path $wtSettings) {
    $json = Get-Content $wtSettings -Raw | ConvertFrom-Json
    $profile = $json.profiles.list | Where-Object { $_.guid -eq $json.defaultProfile }
    if ($profile) {
        $profile.backgroundImage = $imagePath.Replace('\','\\')
        $profile.backgroundImageOpacity = 0.3
        $profile.backgroundImageStretchMode = "uniformToFill"
        $profile.colorScheme = "Vintage"
        $json | ConvertTo-Json -Depth 32 | Set-Content -Path $wtSettings -Encoding UTF8
    }
}

# --- Choco Apps ---
Install-ChocoPackages @(
    "meld", "screentogif", "autohotkey", "python", "libreoffice-fresh", "shotcut", "sharex",
    "postman", "vscode", "onecommander", "dbeaver", "github-desktop", "gh", "7zip", "anydesk",
    "brave", "cpu-z", "file-converter", "flowlauncher", "monitorian", "notepadplusplus", "obs-studio",
    "putty", "winscp", "quicklook", "translucenttb", "warp", "bat", "fzf", "curl", "audacity",
    "ffmpeg", "vlc", "yt-dlp", "bcuninstaller", "crystaldiskinfo", "crystalmark", "google-drive",
    "virtualbox", "teracopy", "treesizefree", "corretto21jdk 21.0.7.61", "corretto17jdk 17.0.15.61", "pdfarranger", "unigetui", "sumatrapdf"
)

# --- PowerShell modules ---
Install-Module PSFzf -Scope CurrentUser -Force

# --- Install Everything ---
Download-And-Install -Url "https://www.voidtools.com/Everything-1.5a.x64-Setup.exe" -OutFile "$TempDir\everything.exe" -Execute

# --- Windhawk (manual install) ---
Start-Process "https://windhawk.net/download"

# --- WSL ---
wsl --install

# --- Visual Studio ---
Download-And-Install -Url "https://aka.ms/vs/17/release/vs_community.exe" -OutFile "$TempDir\vs_community.exe"
Start-Process -FilePath "$TempDir\vs_community.exe" -ArgumentList @(
    "--quiet", "--wait", "--norestart", "--nocache",
    "--add", "Microsoft.VisualStudio.Workload.CoreEditor",
    "--add", "Microsoft.VisualStudio.Workload.NetWeb",
    "--add", "Microsoft.VisualStudio.Workload.ManagedDesktop",
    "--includeRecommended"
) -NoNewWindow -Wait
Remove-Item "$TempDir\vs_community.exe"

# --- Autoruns ---
$zipPath = "$TempDir\Autoruns.zip"
$installDir = "C:\Tools\Autoruns"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Autoruns.zip" -OutFile $zipPath
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $installDir)
Remove-Item $zipPath
Start-Process "$installDir\Autoruns64.exe"

# --- .NET Desktop Runtimes ---
foreach ($id in 3,5,7,8,9) {
    winget install --id "Microsoft.DotNet.DesktopRuntime.$id" -e --accept-package-agreements --accept-source-agreements
}
winget install --id NuGet.NuGetCommandLine -e

$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

if (-not (Test-Path $settingsPath)) {
    Write-Error "❌ Windows Terminal settings.json not found. Please launch Windows Terminal at least once."
    exit 1
}

$json = Get-Content $settingsPath -Raw | ConvertFrom-Json

# Set the launch size and position
$json.initialCols = 190
$json.initialRows = 60
$json.initialPosition = "22,22"

# Save the changes
$json | ConvertTo-Json -Depth 32 | Set-Content -Path $settingsPath -Encoding UTF8

Write-Host "✅ Windows Terminal launch size and position updated successfully."

Write-Host "`n✅ All installations and configurations completed." -ForegroundColor Green
