# Set console output encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Initialize Oh My Posh once at startup, not on idle
if (-not $global:OhMyPoshInitialized) {
    oh-my-posh init pwsh --config 'D:\repos\zsh-pwsh-wt\windows-pws-posh\kalimod.omp.json' | Invoke-Expression
    $global:OhMyPoshInitialized = $true
}

# Calculate padding and message for custom prompt
$width = [console]::WindowWidth
$message = " I can always do it tomorrow... "
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
    $message = " I can always do it tomorrow... "
    $messageLength = $message.Length

    # Calculate padding on each side of the message
    $paddingLength = [math]::Max(0, ($width - $messageLength) / 2)
    $padding = "ˍ" * ($paddingLength-1)

    # Construct the result line
    $result = $padding + $message + $padding
    [System.Environment]::SetEnvironmentVariable("PROMPT_LINE", $result, [System.EnvironmentVariableTarget]::Process)
}

Import-Module Terminal-Icons

# Set PSReadLine options
set-psreadlineoption -predictionviewstyle listview
set-alias py python
set-alias cc cls
Set-PSReadLineOption –HistoryNoDuplicates:$True


cls