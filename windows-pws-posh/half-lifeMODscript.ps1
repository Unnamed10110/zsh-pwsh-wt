# DynamicLine.ps1
#try { $width = [System.Console]::WindowWidth; Write-Output (-join ('─' * ([math]::Max($width - 1, 1)))) } catch { Write-Output '─' }


$ErrorActionPreference = 'Stop'; try { $leftSegment = '$( [System.Console]::WindowWidth)'; $rightSegment = ''; $totalWidth = [System.Console]::WindowWidth; $leftLength = $leftSegment.Length; $rightLength = $rightSegment.Length; $lineLength = $totalWidth - $leftLength - $rightLength - 2; if ($lineLength -gt 0) { '─' * $lineLength } else { '─' } } catch { '─' }