# Function to update Notepad tab with file path
function Update-NotepadTab {
    $notepadProcess = Get-Process notepad -ErrorAction SilentlyContinue
    if ($notepadProcess) {
        $notepadPath = $notepadProcess.MainModule.FileName
        $notepadHandle = $notepadProcess.Id
        $notepadTitle = [System.Diagnostics.Process]::GetProcessById($notepadHandle).MainWindowTitle

        if ($notepadTitle -and $notepadTitle.StartsWith("Notepad: ")) {
            $filePath = $notepadTitle.Substring(8)
            $newTitle = "Notepad: $filePath"
            $notepadProcess.MainWindowTitle = $newTitle
        }
    }
}

# Run the function
Update-NotepadTab
pause