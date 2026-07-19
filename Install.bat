@echo off
title Vortex Pharmacy - Installer Bootstrapper
echo ========================================================
echo  Vortex Pharmacy Setup Bootstrapper
echo ========================================================
echo.
echo  This script will automatically bypass the PowerShell execution policy,
echo  install the self-signed certificate, and install the MSIX application.
echo.
echo  Please click "Yes" on any security confirmation dialogs that appear.
echo.

:: Get the directory of the batch file
set "SCRIPT_DIR=%~dp0"

:: Run the Install.ps1 script bypassing ExecutionPolicy
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Install.ps1"

exit /b %ERRORLEVEL%
