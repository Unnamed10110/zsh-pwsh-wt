# Path to the wallpaper image
$imagePath = "D:\pictures\space-travel-to-the-eagle-nebula-galaxy-free-video.jpg"


# Function to update the wallpaper for all monitors
function Set-Wallpaper {
    param (
        [string]$ImagePath
    )
    
    # Import required .NET types for system wallpaper
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@

    # SPI_SETDESKWALLPAPER = 20, SPIF_UPDATEINIFILE = 0x01, SPIF_SENDCHANGE = 0x02
    $SPI_SETDESKWALLPAPER = 20
    $SPIF_UPDATEINIFILE = 0x01
    $SPIF_SENDCHANGE = 0x02

    # Call the SystemParametersInfo API to set the wallpaper
    [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $ImagePath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)
}

# Set wallpaper on the primary screen and all connected monitors
Set-Wallpaper -ImagePath $imagePath

# Get all monitors connected to the system and set wallpaper on each one
$monitors = Get-WmiObject -Class Win32_DesktopMonitor
foreach ($monitor in $monitors) {
    Set-Wallpaper -ImagePath $imagePath
}

Write-Host "Wallpaper updated for all monitors."
