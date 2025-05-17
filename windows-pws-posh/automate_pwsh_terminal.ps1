Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs

choco install powershell-core


winget install --id Microsoft.Powershell --source winget --accept-source-agreements --accept-package-agreements

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))


winget install --id Microsoft.WindowsTerminal --source winget --accept-package-agreements

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Unnamed10110/zsh-pwsh-wt/master/windows-pws-posh/Microsoft.PowerShell_profile.ps1" -OutFile $PROFILE -UseBasicParsing
Install-Module Terminal-Icons
.$PROFILE

$fontUrl = "https://github.com/Unnamed10110/appsFiles_repo/raw/master/CascadiaCode-2407.24/otf/static/CascadiaCodeNF-SemiLight.otf"
$fontPath = "$env:TEMP\CascadiaCodeNF-SemiLight.otf"

Invoke-WebRequest -Uri $fontUrl -OutFile $fontPath
$fontDest = "$env:WINDIR\Fonts\CascadiaCodeNF-SemiLight.otf"
Copy-Item $fontPath -Destination $fontDest -Force

$ShellApp = New-Object -ComObject Shell.Application
$Folder = $ShellApp.Namespace(0x14)
$Folder.CopyHere($fontPath)



$wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

if (-Not (Test-Path $wtSettings)) {
    Write-Error "Windows Terminal settings.json not found. Open Windows Terminal at least once first."
} else {
    $json = Get-Content $wtSettings -Raw | ConvertFrom-Json

    foreach ($profile in $json.profiles.list) {
        if ($profile.font) {
            $profile.font.face = "Cascadia Code NF SemiLight"
        } else {
            $profile | Add-Member -MemberType NoteProperty -Name font -Value @{ face = "Cascadia Code NF SemiLight" }
        }
    }

    $json | ConvertTo-Json -Depth 5 | Set-Content -Path $wtSettings -Encoding UTF8
    Write-Host "Font updated to 'Cascadia Code NF SemiLight' in all profiles."
}

# Step 1: Install PowerShell Core using winget
winget install --id Microsoft.Powershell --source winget --accept-package-agreements --accept-source-agreements

# Wait a few seconds to allow installation to complete
Start-Sleep -Seconds 5

# Step 2: Locate Windows Terminal settings.json
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (-not (Test-Path $settingsPath)) {
    Write-Error "❌ Windows Terminal settings.json not found. Please launch Windows Terminal at least once."
    return
}

# Step 3: Load and parse settings.json
$json = Get-Content $settingsPath -Raw | ConvertFrom-Json

# Step 4: Find the PowerShell Core profile (pwsh)
$pwshProfile = $json.profiles.list | Where-Object { $_.commandline -match "pwsh.exe" }

if (-not $pwshProfile) {
    # Manually add pwsh profile if not found
    $pwshPath = "$env:ProgramFiles\PowerShell\7\pwsh.exe"
    if (-not (Test-Path $pwshPath)) {
        Write-Error "❌ pwsh.exe not found at $pwshPath"
        return
    }

    $guid = [guid]::NewGuid().ToString()
    $pwshProfile = [pscustomobject]@{
        guid = $guid
        name = "PowerShell"
        commandline = $pwshPath
        hidden = $false
    }

    $json.profiles.list += $pwshProfile
}

# Step 5: Set pwsh as the default profile
$json.defaultProfile = $pwshProfile.guid

# Step 6: Save settings.json
$json | ConvertTo-Json -Depth 5 | Set-Content -Path $settingsPath -Encoding utf8

Write-Host "✅ PowerShell Core (pwsh) installed and set as default in Windows Terminal."


@'
{
  "$help": "https://aka.ms/terminal-documentation",
  "$schema": "https://aka.ms/terminal-profiles-schema",
  "actions": [],
  "copyFormatting": "none",
  "copyOnSelect": false,
  "defaultProfile": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
  "firstWindowPreference": "persistedWindowLayout",
  "initialCols": 190,
  "initialPosition": "22,22",
  "initialRows": 60,
  "keybindings": [
    {
      "id": "Terminal.CopyToClipboard",
      "keys": "ctrl+c"
    },
    {
      "id": "Terminal.FindText",
      "keys": "ctrl+shift+f"
    },
    {
      "id": "Terminal.PasteFromClipboard",
      "keys": "ctrl+v"
    },
    {
      "id": "Terminal.DuplicatePaneAuto",
      "keys": "alt+shift+d"
    }
  ],
  "newTabMenu": [
    {
      "type": "remainingProfiles"
    }
  ],
  "profiles": {
    "defaults": {
      "backgroundImage": "D:\\pillarsofcreation_0000.png",
      "backgroundImageOpacity": 0.2,
      "colorScheme": "Vintage",
      "elevate": true,
      "font": {
        "face": "Cascadia Code NF SemiLight",
        "size": 8
      }
    },
    "list": [
      {
        "commandline": "%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
        "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
        "hidden": false,
        "name": "Windows PowerShell",
        "font": {
          "face": "Cascadia Code NF SemiLight"
        }
      },
      {
        "commandline": "%SystemRoot%\\System32\\cmd.exe",
        "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
        "hidden": false,
        "name": "Command Prompt",
        "font": {
          "face": "Cascadia Code NF SemiLight"
        }
      },
      {
        "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
        "hidden": false,
        "name": "PowerShell",
        "source": "Windows.Terminal.PowershellCore",
        "font": {
          "face": "Cascadia Code NF SemiLight"
        }
      },
      {
        "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
        "hidden": false,
        "name": "Azure Cloud Shell",
        "source": "Windows.Terminal.Azure",
        "font": {
          "face": "Cascadia Code NF SemiLight"
        }
      },
      {
        "guid": "{3984f9a1-d1ea-582e-b03c-262e6b2e4196}",
        "hidden": false,
        "name": "Developer Command Prompt for VS 2022",
        "source": "Windows.Terminal.VisualStudio",
        "font": {
          "face": "Cascadia Code NF SemiLight"
        }
      },
      {
        "guid": "{9ebf6c01-a391-555e-a858-9a3a66e7009a}",
        "hidden": false,
        "name": "Developer PowerShell for VS 2022",
        "source": "Windows.Terminal.VisualStudio",
        "font": {
          "face": "Cascadia Code NF SemiLight"
        }
      },
      {
        "guid": "{2ece5bfe-50ed-5f3a-ab87-5cd4baafed2b}",
        "hidden": false,
        "name": "Git Bash",
        "source": "Git",
        "font": {
          "face": "Cascadia Code NF SemiLight"
        }
      },
      {
        "guid": "{3ce07552-ba2c-567a-b495-6f75939a2d92}",
        "hidden": false,
        "name": "kali-linux",
        "source": "Microsoft.WSL",
        "font": {
          "face": "Cascadia Code NF SemiLight"
        }
      }
    ]
  },
  "schemes": [],
  "themes": [],
  "windowingBehavior": "useExisting"
}
'@ | Set-Content "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Encoding UTF8

choco install meld -y
choco install screentogif -y
choco install autohotkey -y
$downloadUrl = "https://www.voidtools.com/Everything-1.5a.x64-Setup.exe"
$installerPath = "$env:TEMP\Everything-1.5a-Setup.exe"

Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

Start-Process -FilePath $installerPath -Wait


$installerUrl = "https://windhawk.net/download"
Start-Process $installerUrl

choco install python -y

choco install libreoffice-fresh -y

choco install shotcut -y

choco install sharex -y

choco install postman -y

choco install vscode -y

choco install onecommander -y

choco install dbeaver -y

choco install github-desktop -y

choco install gh -y

wsl --install

choco install 7zip -y

choco install anydesk brave cpu-z file-converter flowlauncher openjdk17 openjdk21 openjdk24 monitorian notepadplusplus obs-studio putty winscp quicklook translucenttb warp -y

choco install bat -y

choco install fzf -y
Install-Module PSFzf

choco install curl

# Define installer location
$vsInstallerUrl = "https://aka.ms/vs/17/release/vs_community.exe"
$installerPath = "$env:TEMP\vs_community.exe"

# Download the Visual Studio installer
Invoke-WebRequest -Uri $vsInstallerUrl -OutFile $installerPath

# Install with default workload (modify this line to suit your needs)
Start-Process -FilePath $installerPath -ArgumentList `
    "--quiet", `
    "--wait", `
    "--norestart", `
    "--nocache", `
    "--add", "Microsoft.VisualStudio.Workload.CoreEditor", `
    "--add", "Microsoft.VisualStudio.Workload.NetWeb", `
    "--add", "Microsoft.VisualStudio.Workload.ManagedDesktop", `
    "--includeRecommended" `
    -NoNewWindow -Wait

# Clean up installer
Remove-Item $installerPath

Write-Host "Visual Studio Community installation script completed."


# Define download and install paths
$autorunsUrl = "https://download.sysinternals.com/files/Autoruns.zip"
$zipPath = "$env:TEMP\Autoruns.zip"
$installDir = "C:\Tools\Autoruns"

# Create install directory
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

# Download the zip file
Invoke-WebRequest -Uri $autorunsUrl -OutFile $zipPath

# Extract the zip
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $installDir)

# Clean up
Remove-Item $zipPath

# Launch Autoruns GUI
Start-Process "$installDir\Autoruns64.exe"

Write-Host "Autoruns installed and started from: $installDir"

winget install --id Microsoft.DotNet.DesktopRuntime.3_1 -e
winget install --id Microsoft.DotNet.DesktopRuntime.5 -e
winget install --id Microsoft.DotNet.DesktopRuntime.7 -e
winget install --id Microsoft.DotNet.DesktopRuntime.8 -e
winget install --id Microsoft.DotNet.DesktopRuntime.9 -e
winget install --id=NuGet.NuGetCommandLine -e
choco install audacity -y
choco install ffmpeg -y
choco install vlc -y
choco install yt-dlp -y
choco install bcuninstaller -y
choco install crystaldiskinfo crystalmark google-drive virtualbox teracopy treesizefree unigetui sumatrapdf -y








# Variables
$imageUrl = "https://raw.githubusercontent.com/Unnamed10110/zsh-pwsh-wt/master/pillarsofcreation_0000.png"
$imagePath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\pillarsofcreation_0000.png"
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Download image
Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath -UseBasicParsing

# Load settings.json
if (Test-Path $settingsPath) {
    $json = Get-Content $settingsPath -Raw | ConvertFrom-Json
} else {
    Write-Error "Windows Terminal settings.json not found at $settingsPath"
    exit 1
}

# Get default profile guid
$defaultGuid = $json.defaultProfile

# Find the default profile object
$profile = $json.profiles.list | Where-Object { $_.guid -eq $defaultGuid }

if (-not $profile) {
    Write-Error "Default profile with guid $defaultGuid not found."
    exit 1
}

# Set background image path (use forward slashes or escaped backslashes)
$profile.backgroundImage = $imagePath.Replace('\','\\')

# Set background image opacity to 0.3 (30%)
$profile.backgroundImageOpacity = 0.3

# Optional: keep background image fixed (no scrolling)
$profile.backgroundImageStretchMode = "uniformToFill"

# Save updated settings.json
$json | ConvertTo-Json -Depth 32 | Set-Content -Encoding UTF8 $settingsPath
# Set color scheme to Vintage
$profile.colorScheme = "Vintage"

Write-Host "Background image set with 30% opacity for the default Windows Terminal profile."
Write-Host "Please restart Windows Terminal to see changes."

