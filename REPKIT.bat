@echo off
title WinKit - System Repair ^& Health
color 0B
:: Discord: hxnrylsd | GitHub: https://github.com/HxnryLSD

:: --- Admin check ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Administrator rights required.
    color 0C
    timeout /t 5 >nul
    exit /b 1
)

echo ============================================
echo   WinKit System Repair - Starting...
echo ============================================
echo.

:: --------------------------------------------------
:: SECTION 1 - Driver scan
:: --------------------------------------------------
echo ===== [1/10] Scanning for driver changes =====
pnputil /scan-devices
echo.

:: --------------------------------------------------
:: SECTION 2 - DISM health checks
:: --------------------------------------------------
echo ===== [2/10] DISM - Checking image health =====
dism /online /cleanup-image /scanhealth
echo.

echo ===== [3/10] DISM - Restoring image health =====
dism /online /cleanup-image /restorehealth
echo.

echo ===== [4/10] DISM - Cleaning up WinSxS =====
dism /online /cleanup-image /startcomponentcleanup
echo.

:: --------------------------------------------------
:: SECTION 3 - SFC
:: --------------------------------------------------
echo ===== [5/10] Verifying system files (SFC) =====
sfc /scannow
echo.

:: --------------------------------------------------
:: SECTION 4 - Disk check
:: --------------------------------------------------
echo ===== [6/10] Scheduling disk check on next boot =====
echo Y | chkdsk C: /f /r
echo   ^> Note: Run will complete after reboot
echo.

:: --------------------------------------------------
:: SECTION 5 - Network reset
:: --------------------------------------------------
echo ===== [7/10] Resetting network stack =====
ipconfig /flushdns
netsh int ip reset
netsh winsock reset
echo.

:: --------------------------------------------------
:: SECTION 6 - Windows Update reset
:: --------------------------------------------------
echo ===== [8/10] Resetting Windows Update cache =====
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
rd /s /q C:\Windows\SoftwareDistribution\Download >nul 2>&1
if not exist C:\Windows\SoftwareDistribution\Download md C:\Windows\SoftwareDistribution\Download >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo   ^> Windows Update cache cleared.
echo.

:: --------------------------------------------------
:: SECTION 7 - Store reset
:: --------------------------------------------------
echo ===== [9/10] Resetting Microsoft Store cache =====
taskkill /f /im WinStore.App.exe >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache" >nul 2>&1
echo   ^> Store cache cleared (no window needed).

:: --------------------------------------------------
:: SECTION 8 - Hibernate
:: --------------------------------------------------
echo ===== [10/10] Disabling hibernation =====
powercfg /h off
echo   ^> Hibernation disabled (frees disk space).
echo.

:: --------------------------------------------------
:: Done
:: --------------------------------------------------
echo ============================================
echo   All repair steps executed.
echo   REBOOT REQUIRED for chkdsk and SFC fixes.
echo ============================================
echo.
pause
