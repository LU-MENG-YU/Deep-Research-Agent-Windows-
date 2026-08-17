@echo off
setlocal

set "WORKDIR=%USERPROFILE%\Documents\DeepResearch"

if not exist "%WORKDIR%" (
    mkdir "%WORKDIR%"
)

where hermes >nul 2>&1
if errorlevel 1 (
    echo Hermes was not found in PATH.
    echo Please confirm that Hermes is installed and that "hermes" works in PowerShell.
    pause
    exit /b 1
)

cd /d "%WORKDIR%"
hermes desktop

endlocal
exit /b
