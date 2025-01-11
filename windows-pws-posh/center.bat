@echo off
setlocal enabledelayedexpansion
set width=%1
::set width=80
set TEXT=─
set result=
for /L %%i in (1,1,%width%) do (
    set result=!result!!TEXT!
)
:: Output the result directly to stdout
::echo !result!

echo %PROMPT_LINE%
endlocal