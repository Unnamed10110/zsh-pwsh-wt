import subprocess
import time
import os
# ANSI color codes for PowerShell-like colors
CYAN = '\033[96m'
GREEN = '\033[92m'
RED = '\033[91m'
RESET = '\033[0m'

# PowerShell script as a string
pwsh_script = '''
Add-Type -AssemblyName System.Windows.Forms | Out-Null

try {
    rm -Path "~\\AppData\\Local\\temp\\*" -Recurse -Force
    Write-Host -ForegroundColor Cyan "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | Out-Host
    Write-Host -ForegroundColor Green "rm -Path ~\\AppData\\Local\\temp\\* -Recurse -Force" | Out-Host
    Write-Host -ForegroundColor Cyan "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | Out-Host

    # Ensure console output is flushed before finishing
    [System.Console]::Out.Flush()
} catch {
    Write-Host -ForegroundColor Red "An error occurred: $($_.Exception.Message)"
    exit 1
}

#Pause
'''

# Execute the PowerShell script
try:
    result = subprocess.run(
        ['pwsh', '-Command', pwsh_script],
        check=True, capture_output=True, text=True
    )
    
    # Print any error messages first
    if result.stderr:
        print("Errors:\n", result.stderr)
    
    # Print the output with colors
    output_lines = result.stdout.splitlines()
    for line in output_lines:
        if "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" in line:
            print(f"{CYAN}{line}{RESET}")
        elif "rm -Path ~\\AppData\\Local\\temp\\* -Recurse -Force" in line:
            print(f"{GREEN}{line}{RESET}")
        else:
            print(line)
    
    # Display the pop-up window after all outputs
    subprocess.run(
        ['pwsh', '-Command', 'Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show("Unused temporary files deleted!")']
    )
    
    os.system("pause")
    
except subprocess.CalledProcessError as e:
    print(f"{RED}Error occurred: {e}{RESET}")
    print(f"{RED}Details: {e.stderr}{RESET}")
    os.system("pause")
