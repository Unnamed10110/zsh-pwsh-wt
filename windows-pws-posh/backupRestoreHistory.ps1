Add-Type -AssemblyName System.Windows.Forms

function Choose-Folder {
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Select a folder to back up to or restore from:"
    $dialog.ShowNewFolderButton = $true

    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $dialog.SelectedPath
    } else {
        throw "❌ Folder selection canceled."
    }
}

function Backup-History($dest) {
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    
    # PowerShell history
    $pwshHist = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
    if (Test-Path $pwshHist) {
        Copy-Item $pwshHist "$dest\pwsh-history_$timestamp.txt"
        Write-Host "✅ pwsh history backed up."
    }

    # PowerShell 5.x history (if different)
    $ps5Hist = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
    if ((Test-Path $ps5Hist) -and ($ps5Hist -ne $pwshHist)) {
        Copy-Item $ps5Hist "$dest\ps5-history_$timestamp.txt"
        Write-Host "✅ PowerShell 5.x history backed up."
    }

    # Windows Terminal settings
    $wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path $wtSettings) {
        Copy-Item $wtSettings "$dest\WT-settings_$timestamp.json"
        Write-Host "✅ Windows Terminal settings backed up."
    }

    Write-Host "`n🗂️  Backup complete to: $dest"
}

function Restore-History($source) {
    $choices = Get-ChildItem -Path $source -File | Where-Object {
        $_.Name -match 'pwsh-history|ps5-history|WT-settings'
    }

    if (-not $choices) {
        Write-Host "❌ No backup files found in $source"
        return
    }

    foreach ($file in $choices) {
        $target = switch -Regex ($file.Name) {
            'pwsh-history' { "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"; break }
            'ps5-history' { "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"; break }
            'WT-settings' { "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"; break }
        }

        if ($target) {
            Copy-Item $file.FullName $target -Force
            Write-Host "✅ Restored $($file.Name) to $target"
        }
    }

    Write-Host "`n♻️  Restore complete. You may need to restart PowerShell/Terminal."
}

# --- MAIN ---

try {
    $choice = Read-Host "Type 'b' to backup or 'r' to restore"

    $folder = Choose-Folder

    switch ($choice.ToLower()) {
        'b' { Backup-History -dest $folder }
        'r' { Restore-History -source $folder }
        default { Write-Host "❌ Invalid choice. Use 'b' or 'r'." }
    }
}
catch {
    Write-Host $_.Exception.Message
}
