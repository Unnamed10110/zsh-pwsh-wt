$failedInstalls = @()
Get-Content -Path "D:\installed_programs.txt" | Select-Object -Skip 2 | ForEach-Object {
    Write-Output "Processing line: $_"
    $parts = $_ -split ','
    Write-Output "Split parts: $($parts -join ', ')"
    if ($parts.Length -eq 2) {
        $id = $parts[1].Trim()
        Write-Output "Extracted ID: $id"
        if ($id -ne '') {
            Write-Output "Trying to install: $id"
            try {
                winget install --id $id --source winget -e -h
                Write-Output "Successfully installed: $id"
            } catch {
                Write-Output "Failed to install: $id"
                $failedInstalls += "$($_)"
            }
        } else {
            Write-Output "ID is empty"
            $failedInstalls += "$($_)"
        }
    } else {
        Write-Output "Insufficient parts"
        $failedInstalls += "$($_)"
    }
}

# Save failed installations to a file
$failedInstalls | Set-Content -Path "D:\failed_installs.txt"
