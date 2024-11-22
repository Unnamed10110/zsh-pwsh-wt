Add-Type -AssemblyName System.Windows.Forms

# Function to display a file selection dialog
function Get-FileDialog {
    param (
        [string]$Title = "Select a File",
        [string]$Filter = "Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
    )
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.Title = $Title
    $fileDialog.Filter = $Filter
    if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $fileDialog.FileName
    } else {
        throw "File selection was canceled."
    }
}

# Function to display a folder selection dialog
function Get-FolderDialog {
    param (
        [string]$Description = "Select a Folder"
    )
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = $Description
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderDialog.SelectedPath
    } else {
        throw "Folder selection was canceled."
    }
}

# Step 1: Select the input file
try {
    $inputFile = Get-FileDialog -Title "Select the Input File with File Paths"
    Write-Host "Selected Input File: $inputFile"
} catch {
    Write-Error $_
    exit
}

# Step 2: Select the destination folder
try {
    $destinationFolder = Get-FolderDialog -Description "Select the Destination Folder"
    Write-Host "Selected Destination Folder: $destinationFolder"
} catch {
    Write-Error $_
    exit
}

# Step 3: Process and move the files
try {
    $filePaths = Get-Content $inputFile
    foreach ($filePath in $filePaths) {
        # Remove the enclosing double quotes and trim any leading/trailing spaces
        $filePath = $filePath.Trim('"').Trim()

        # Check if the file exists
        if (Test-Path $filePath) {
            Write-Host "Moving file: $filePath to $destinationFolder"
            Move-Item -Path $filePath -Destination $destinationFolder -Force
        } else {
            Write-Warning "File not found: $filePath"
        }
    }
    Write-Host "File processing completed!" -ForegroundColor Green
} catch {
    Write-Error $_
    exit
}

pause
