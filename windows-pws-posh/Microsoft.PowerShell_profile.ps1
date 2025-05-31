# Set console output encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Initialize Oh My Posh once at startup, not on idle
if (-not $global:OhMyPoshInitialized) {
    oh-my-posh init pwsh --config 'D:\repos\zsh-pwsh-wt\windows-pws-posh\kalimod.omp.json' | Invoke-Expression
    $global:OhMyPoshInitialized = $true
}

# Calculate padding and message for custom prompt
$width = [console]::WindowWidth
$message = "... I can be free, it just takes making the last decision I will ever make ..."
$messageLength = $message.Length

# Calculate padding on each side of the message
$paddingLength = [math]::Max(0, ($width - $messageLength) / 2)
$padding = "ˍ" * ($paddingLength-1)

# Construct the result line
$result = $padding + $message + $padding
[System.Environment]::SetEnvironmentVariable("PROMPT_LINE", $result, [System.EnvironmentVariableTarget]::Process)

# Register idle event for other tasks (without reinitializing Oh My Posh)
Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -Action {
    # Only update the prompt line, don't reinitialize Oh My Posh
    $width = [console]::WindowWidth
    $message = "... I can be free, it just takes making the last decision I will ever make ..."
    $messageLength = $message.Length

    # Calculate padding on each side of the message
    $paddingLength = [math]::Max(0, ($width - $messageLength) / 2)
    $padding = "ˍ" * ($paddingLength-1)

    # Construct the result line
    $result = $padding + $message + $padding
    [System.Environment]::SetEnvironmentVariable("PROMPT_LINE", $result, [System.EnvironmentVariableTarget]::Process)
}

# Check if Terminal-Icons module is available
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Write-Host "Terminal-Icons module not found. Installing..." -ForegroundColor Yellow
    try {
        Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -AllowClobber
        Write-Host "Terminal-Icons installed successfully." -ForegroundColor Green
    } catch {
        Write-Error "Failed to install Terminal-Icons: $_"
        return
    }
} else {
    Write-Host "" -ForegroundColor Green
}

# Import the module
try {
    Import-Module Terminal-Icons -Force
    #Write-Host "Terminal-Icons module imported." -ForegroundColor Cyan
} catch {
    Write-Error "Failed to import Terminal-Icons: $_"
}

# Set PSReadLine options
set-psreadlineoption -predictionviewstyle listview
set-alias py python
set-alias cc cls
set-alias ll dir
function Kill-Proc {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Name
    )

    if ($Name -like "*.exe") {
        $Name = $Name -replace '\.exe$', ''
    }

    $procs = Get-Process -Name $Name -ErrorAction SilentlyContinue

    if ($procs) {
        $procs | Stop-Process -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "❌ No matching process found for: $Name"
    }
}
Set-Alias -Name kill -Value Kill-Proc

function fzfcat {
    fzf --preview 'bat --color=always {}'
}



Set-PSReadLineOption –HistoryNoDuplicates:$True

function k8sqa {
    kubectl --kubeconfig "C:\Users\sbritos\OneDrive - BEPSA DEL PARAGUAY SAECA\workspace_sbritos\HUs\kubeconfigk8sqa" config use-context k8sqa
}
function k3sqa {
    kubectl --kubeconfig "C:\Users\sbritos\OneDrive - BEPSA DEL PARAGUAY SAECA\workspace_sbritos\HUs\kubeconfigk3sqa" config use-context k3sqa
}
function k8sdev {
    kubectl --kubeconfig "C:\Users\sbritos\OneDrive - BEPSA DEL PARAGUAY SAECA\workspace_sbritos\HUs\kubeconfigk8sdev" config use-context kubernetes-admin@kubernetes
}
function k3sdev {
    kubectl --kubeconfig "C:\Users\sbritos\OneDrive - BEPSA DEL PARAGUAY SAECA\workspace_sbritos\HUs\kubeconfigk3sdev" config use-context default
}







