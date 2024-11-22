try {
    # Ensure the script runs as administrator
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error "Please run this script as Administrator."
        exit
    }

    Write-Host "Starting disk cleanup. This may take a while..." -ForegroundColor Green

    # 1. Clean Temporary Files
    Write-Host "Cleaning temporary files..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:WinDir\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    # 2. Clear the Recycle Bin
    Write-Host "Clearing Recycle Bin..."
    $drives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root
    foreach ($drive in $drives) {
        $recycleBin = "$drive\$Recycle.Bin"
        if (Test-Path $recycleBin) {
            Get-ChildItem -Path "$recycleBin\*" -Recurse -Force -ErrorAction SilentlyContinue |
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    # 3. Clean Windows Update Cache
    Write-Host "Cleaning Windows Update cache..."
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service -Name wuauserv

    # 4. Remove Old System Restore Points
    Write-Host "Removing old system restore points..."
    vssadmin delete shadows /for=c: /oldest | Out-Null

    # 5. Run Disk Cleanup Tool (Silent Mode)
    Write-Host "Running Disk Cleanup..."
    cmd.exe /c "cleanmgr /sagerun:1"

    # 6. Disable Hibernate (Optional)
    #Write-Host "Disabling Hibernate..."
    #powercfg -h off

    # 7. Remove Unused Features
    Write-Host "Removing unused Windows features..."
    try {
        Get-WindowsOptionalFeature -Online | Where-Object { $_.State -eq "Enabled" } |
            ForEach-Object { 
                Disable-WindowsOptionalFeature -Online -FeatureName $_.FeatureName -NoRestart -ErrorAction SilentlyContinue 
            }
    } catch {
        Write-Warning "Failed to access Windows Optional Features. Skipping this step."
    }

    # 8. Clear Delivery Optimization Files
    Write-Host "Clearing Delivery Optimization files..."
    Remove-Item -Path "C:\Windows\SoftwareDistribution\DataStore\*" -Recurse -Force -ErrorAction SilentlyContinue

    # 9. Analyze Disk Space Usage (Optional, Comment out if not needed)
    Write-Host "Analyzing disk space usage for large files..."
    Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | 
        Where-Object { $_.PSIsContainer -eq $false } |
        Sort-Object Length -Descending | 
        Select-Object FullName, @{Name="Size (MB)"; Expression={[math]::Round($_.Length / 1MB, 2)}} -First 50 |
        ForEach-Object {
            # Correctly print the full file path enclosed in double quotes
            Write-Host "`"$( $_.FullName )`""
        }

    Write-Host "Disk cleanup completed!" -ForegroundColor Green


    # Read-Host -Prompt "Press any key to exit."
    #pause
} catch {
    Write-Error "An error occurred: $_"
} finally {
    Read-Host "Press Enter to exit"
}
