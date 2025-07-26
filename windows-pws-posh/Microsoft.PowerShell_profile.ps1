# ─────────────────────────────────────────────────────────────────────────────
# ✅ Console output encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ─────────────────────────────────────────────────────────────────────────────
# ✅ Init Oh My Posh (only once)
if (-not $global:OhMyPoshInitialized) {
    oh-my-posh init pwsh --config 'D:\repos\zsh-pwsh-wt\windows-pws-posh\kalimod.omp.json' | Invoke-Expression
    $global:OhMyPoshInitialized = $true
}

# ─────────────────────────────────────────────────────────────────────────────
# ✅ Custom PROMPT_LINE message
$width = [console]::WindowWidth
$message = "... I can be free, it just takes making the last decision I will ever make ..."
$paddingLength = [math]::Max(0, ($width - $message.Length) / 2)
$padding = "ˍ" * ($paddingLength - 1)
$result = $padding + $message + $padding
[System.Environment]::SetEnvironmentVariable("PROMPT_LINE", $result, [System.EnvironmentVariableTarget]::Process)

# ─────────────────────────────────────────────────────────────────────────────
# ✅ Idle event updates only the prompt line
Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -Action {
    $width = [console]::WindowWidth
    $message = "... I can be free, it just takes making the last decision I will ever make ..."
    $paddingLength = [math]::Max(0, ($width - $message.Length) / 2)
    $padding = "ˍ" * ($paddingLength - 1)
    $result = $padding + $message + $padding
    [System.Environment]::SetEnvironmentVariable("PROMPT_LINE", $result, [System.EnvironmentVariableTarget]::Process)
}

# ─────────────────────────────────────────────────────────────────────────────
# ✅ Terminal-Icons module loader
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Write-Host "⚠️ Terminal-Icons not found. Attempting install..." -ForegroundColor Yellow
    try {
        Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -AllowClobber
        Write-Host "✅ Terminal-Icons installed." -ForegroundColor Green
    } catch {
        Write-Error "❌ Failed to install Terminal-Icons: $_"
    }
}

try {
    Import-Module Terminal-Icons -Force -ErrorAction Stop
    Write-Host "📦 Terminal-Icons loaded." -ForegroundColor Cyan
} catch {
    Write-Error "❌ Failed to import Terminal-Icons: $_"
}

# ─────────────────────────────────────────────────────────────────────────────
# ✅ PSReadLine & Aliases
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -HistoryNoDuplicates:$true

Set-Alias py python
Set-Alias cc cls
Set-Alias ll dir
Set-Alias wget wget2

# ─────────────────────────────────────────────────────────────────────────────
# ✅ Kill process by name
function Kill-Proc {
    param([Parameter(Mandatory = $true)][string]$Name)
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
Set-Alias kill Kill-Proc

# ─────────────────────────────────────────────────────────────────────────────
# ✅ fzf + bat preview
function fzfcat {
    fzf --preview 'bat --color=always {}'
}

# ─────────────────────────────────────────────────────────────────────────────
# ✅ Kubernetes context switchers
function k8sqa  { kubectl --kubeconfig "$HOME\OneDrive - BEPSA DEL PARAGUAY SAECA\workspace_sbritos\HUs\kubeconfigk8sqa" config use-context k8sqa }
function k3sqa  { kubectl --kubeconfig "$HOME\OneDrive - BEPSA DEL PARAGUAY SAECA\workspace_sbritos\HUs\kubeconfigk3sqa" config use-context k3sqa }
function k8sdev { kubectl --kubeconfig "$HOME\OneDrive - BEPSA DEL PARAGUAY SAECA\workspace_sbritos\HUs\kubeconfigk8sdev" config use-context kubernetes-admin@kubernetes }
function k3sdev { kubectl --kubeconfig "$HOME\OneDrive - BEPSA DEL PARAGUAY SAECA\workspace_sbritos\HUs\kubeconfigk3sdev" config use-context default }

# ─────────────────────────────────────────────────────────────────────────────
# ✅ OpenRouter models fetcher
function models {
    (Invoke-RestMethod -Uri "https://openrouter.ai/api/v1/models" -Headers $headers).data |
        Sort-Object -Property name |
        Select-Object id, name
}

# ─────────────────────────────────────────────────────────────────────────────
# ✅ AI chat interactive client
function ai {
    $apiKey = "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"
    $model = "deepseek/deepseek-chat:free"

    $headers = @{
        "Authorization" = "Bearer $apiKey"
        "Content-Type"  = "application/json"
        "HTTP-Referer"  = "http://localhost"
        "X-Title"       = "PowerShell Chat"
    }

    $messages = @()
    Write-Host "`n🤖 Chat started. Press Ctrl+C to exit." -ForegroundColor Yellow

    while ($true) {
        try {
            $userInput = Read-Host -Prompt "`n💬 You"
            $messages += @{ role = "user"; content = $userInput }

            $body = @{ model = $model; messages = $messages } | ConvertTo-Json -Depth 10
            $response = Invoke-RestMethod -Uri "https://openrouter.ai/api/v1/chat/completions" `
                                          -Method Post -Headers $headers -Body $body

            $reply = $response.choices[0].message.content
            $messages += @{ role = "assistant"; content = $reply }

            Write-Host "`n🧠 AI:" -ForegroundColor Cyan
            Write-Output $reply
        } catch {
            $errorDetails = $_
            $errorMessage = "❌ API request failed: $($errorDetails.Exception.Message)"
            if ($errorDetails.ErrorDetails.Message) {
                $errorMessage += "`nAdditional details: $($errorDetails.ErrorDetails.Message)"
            }
            Write-Host $errorMessage -ForegroundColor Red
        }
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# ✅ Success message
Write-Host "`n✅ PowerShell profile loaded successfully." -ForegroundColor Green
<#  last modified 26072025 #>