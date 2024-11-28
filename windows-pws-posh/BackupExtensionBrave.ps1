# Define the base path to the Brave profile directory
$baseBraveProfilePath = "$env:USERPROFILE\AppData\Local\BraveSoftware\Brave-Browser\User Data"

# Define the output file path
$outputFilePath = "D:\repos\zsh-pwsh-wt\windows-pws-posh\BraveExtensions.txt"

# Initialize an empty array to collect extension details
$output = @()

# Get the list of profile directories
$profileDirs = Get-ChildItem -Path $baseBraveProfilePath -Directory

# Iterate through each profile directory and check for extensions
foreach ($profileDir in $profileDirs) {
    $extensionsPath = "$($profileDir.FullName)\Extensions"
    if (Test-Path -Path $extensionsPath) {
        $extensions = Get-ChildItem -Path $extensionsPath -Directory
        foreach ($ext in $extensions) {
            $manifestPath = "$($ext.FullName)\manifest.json"
            if (Test-Path -Path $manifestPath) {
                try {
                    $extensionManifest = Get-Content $manifestPath | ConvertFrom-Json
                    $output += [PSCustomObject]@{
                        Profile = $profileDir.Name
                        ExtensionID = $ext.Name
                        ExtensionName = $extensionManifest.name
                    }
                } catch {
                    Write-Warning "Failed to read or parse manifest for extension: $($ext.Name)"
                }
            } else {
                Write-Warning "Manifest file not found for extension: $($ext.Name)"
            }
        }
    }
}

# Save the output to a file
if ($output) {
    $output | Format-Table | Out-String | Set-Content -Path $outputFilePath
    Write-Host "The list of installed Brave extensions has been saved to $outputFilePath"
} else {
    Write-Host "No extensions found or failed to read extension details."
}






pause