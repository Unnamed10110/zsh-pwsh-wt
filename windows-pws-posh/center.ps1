$width = [console]::WindowWidth
$result = "4" * $width
[System.Environment]::SetEnvironmentVariable("PROMPT_LINE", $result, [System.EnvironmentVariableTarget]::Process)
