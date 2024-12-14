# Function to get Wi-Fi SSIDs and Passwords
function Get-WifiPasswords {
    # Get all Wi-Fi profiles
    $profilesOutput = netsh wlan show profiles
    $profiles = @()

    # Extract profile names from the output
    foreach ($line in $profilesOutput) {
        if ($line -match "(?:Nombre de todos los perfiles|All User Profile)\s*:\s*(.+)") {
            $profiles += $matches[1].Trim()
        }
    }

    # If no profiles are found
    if (-not $profiles) {
        Write-Output "No Wi-Fi profiles found."
        return
    }

    # Store results
    $results = @()

    # Loop through each profile and get the password
    foreach ($profile in $profiles) {
        $detailsOutput = netsh wlan show profile name="$profile" key=clear
        $keyContent = $null

        # Extract the password (key content)
        foreach ($detail in $detailsOutput) {
            if ($detail -match "(?:Key Content|Contenido de la clave)\s*:\s*(.+)") {
                $keyContent = $matches[1].Trim()
                break
            }
        }

        # If no key content was found
        if (-not $keyContent) {
            $keyContent = "No password stored"
        }

        # Add to results
        $results += [PSCustomObject]@{
            SSID     = $profile
            Password = $keyContent
        }
    }

    # Output the results in a table
    $results | Format-Table -AutoSize
}

# Run the function
Get-WifiPasswords
