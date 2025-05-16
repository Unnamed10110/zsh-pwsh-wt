# Helper Functions
function Install-ChocoPackage($package) {
    if (-not (choco list --local-only | Select-String "^$package")) {
        choco install $package -y
    } else {
        Write-Host "✔ $package is already installed."
    }
}

function Install-WingetPackage($id) {
    if (-not (winget list | Select-String "$id")) {
        winget install --id $id --source winget --accept-source-agreements --accept-package-agreements
    } else {
        Write-Host "✔ $id is already installed."
    }
}

function Download-File($url, $destination) {
    if (-not (Test-Path $destination)) {
        Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing
    }
}

function Set-ExecutionPolicyBypass {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072
}

# Elevate Script
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
Set-ExecutionPolicyBypass

# Chocolatey install (if not present)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Winget and core installs
Install-WingetPackage "Microsoft.Powershell"
Install-WingetPackage "Microsoft.WindowsTerminal"
Install-WingetPackage "Microsoft.DotNet.DesktopRuntime.3_1"
Install-WingetPackage "Microsoft.DotNet.DesktopRuntime.5"
Install-WingetPackage "Microsoft.DotNet.DesktopRuntime.7"
Install-WingetPackage "Microsoft.DotNet.DesktopRuntime.8"
Install-WingetPackage "Microsoft.DotNet.DesktopRuntime.9"
Install-WingetPackage "NuGet.NuGetCommandLine"

# Install fonts
$fontUrl = "https://github.com/Unnamed10110/appsFiles_repo/raw/master/CascadiaCode-2407.24/otf/static/CascadiaCodeNF-SemiLight.otf"
$fontPath = "$env:TEMP\CascadiaCodeNF-SemiLight.otf"
$fontDest = "$env:WINDIR\Fonts\CascadiaCodeNF-SemiLight.otf"

Download-File $fontUrl $fontPath
Copy-Item $fontPath -Destination $fontDest -Force

$ShellApp = New-Object -ComObject Shell.Application
$ShellApp.Namespace(0x14).CopyHere($fontPath)

# Download PowerShell profile
$profileUrl = "https://raw.githubusercontent.com/Unnamed10110/zsh-pwsh-wt/master/windows-pws-posh/Microsoft.PowerShell_profile.ps1"
Invoke-WebRequest -Uri $profileUrl -OutFile $PROFILE -UseBasicParsing

# Terminal font update
$wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wtSettings) {
    $json = Get-Content $wtSettings -Raw | ConvertFrom-Json
    foreach ($profile in $json.profiles.list) {
        if (-not $profile.font) {
            $profile | Add-Member -MemberType NoteProperty -Name font -Value @{ face = "Cascadia Code NF SemiLight" }
        } else {
            $profile.font.face = "Cascadia Code NF SemiLight"
        }
    }
    $json | ConvertTo-Json -Depth 5 | Set-Content $wtSettings -Encoding UTF8
    Write-Host "✔ Terminal profiles updated with custom font."
} else {
    Write-Error "❌ Windows Terminal settings.json not found. Open Windows Terminal at least once first."
}

# Install Terminal Icons module and run profile
Install-Module Terminal-Icons -Force -Scope CurrentUser
.$PROFILE

# Install Core Software
$chocoApps = @(
    "meld", "screentogif", "autohotkey", "python", "libreoffice-fresh", "shotcut", "sharex", "postman", "vscode",
    "onecommander", "dbeaver", "github-desktop", "gh", "7zip", "anydesk", "brave", "cpu-z", "file-converter",
    "flowlauncher", "openjdk17", "openjdk21", "openjdk24", "monitorian", "notepadplusplus", "obs-studio",
    "putty", "winscp", "quicklook", "translucenttb", "warp", "bat", "fzf", "curl", "audacity", "ffmpeg",
    "vlc", "yt-dlp", "bcuninstaller", "crystaldiskinfo", "crystalmark", "google-drive", "virtualbox",
    "teracopy", "treesizefree", "unigetui", "sumatrapdf"
)

foreach ($app in $chocoApps) {
    Install-ChocoPackage $app
}

# FZF Integration
Install-Module PSFzf -Force -Scope CurrentUser

# WSL Install
wsl --install

# Download and install Everything
$everythingUrl = "https://www.voidtools.com/Everything-1.5a.x64-Setup.exe"
$everythingInstaller = "$env:TEMP\Everything-1.5a-Setup.exe"
Download-File $everythingUrl $everythingInstaller
Start-Process -FilePath $everythingInstaller -Wait

# Windhawk
Start-Process "https://windhawk.net/download"

# Visual Studio Installer
$vsInstaller = "$env:TEMP\vs_community.exe"
$vsUrl = "https://aka.ms/vs/17/release/vs_community.exe"
Download-File $vsUrl $vsInstaller

Start-Process -FilePath $vsInstaller -ArgumentList @(
    "--quiet", "--wait", "--norestart", "--nocache",
    "--add", "Microsoft.VisualStudio.Workload.CoreEditor",
    "--add", "Microsoft.VisualStudio.Workload.NetWeb",
    "--add", "Microsoft.VisualStudio.Workload.ManagedDesktop",
    "--includeRecommended"
) -NoNewWindow -Wait

Remove-Item $vsInstaller -Force
Write-Host "✔ Visual Studio Community installation complete."

# Autoruns
$autorunsUrl = "https://download.sysinternals.com/files/Autoruns.zip"
$zipPath = "$env:TEMP\Autoruns.zip"
$installDir = "C:\Tools\Autoruns"
if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir | Out-Null }

Download-File $autorunsUrl $zipPath
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $installDir)
Remove-Item $zipPath
Start-Process "$installDir\Autoruns64.exe"
Write-Host "✔ Autoruns installed and started."

# Terminal Background Setup
$imageUrl = "https://raw.githubusercontent.com/Unnamed10110/zsh-pwsh-wt/master/pillarsofcreation_0000.png"
$imagePath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\pillarsofcreation_0000.png"
Download-File $imageUrl $imagePath

if (Test-Path $wtSettings) {
    $json = Get-Content $wtSettings -Raw | ConvertFrom-Json
    $profile = $json.profiles.list | Where-Object { $_.guid -eq $json.defaultProfile }

    if ($profile) {
        $profile.backgroundImage = $imagePath.Replace('\', '\\')
        $profile.backgroundImageOpacity = 0.3
        $profile.backgroundImageStretchMode = "uniformToFill"
        $profile.colorScheme = "Vintage"

        $json | ConvertTo-Json -Depth 32 | Set-Content -Encoding UTF8 $wtSettings
        Write-Host "✔ Terminal background image set successfully."
    } else {
        Write-Error "❌ Default terminal profile not found."
    }
} else {
    Write-Error "❌ Terminal settings.json not found."
}
