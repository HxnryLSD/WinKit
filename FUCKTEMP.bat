@echo off
title WinKit - Deep Temp Cleaner
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
echo   WinKit Deep Temp Cleaner
echo ============================================
echo.
echo WARNING: This will delete:
echo   - Prefetch, Temp folders, Crash dumps
echo   - Browser cache, Error reports, Logs
echo   - Windows Update cache
echo   - ALL users' Recycle Bin
echo.
choice /c YN /m "Continue"
if %errorlevel% neq 1 (
    echo Skipped.
    timeout /t 3 >nul
    exit /b 0
)
echo.

:: ============================================
:: System Temp Directories
:: ============================================
echo --- System Temp ---

echo [1/9] Cleaning Prefetch...
takeown /F C:\Windows\Prefetch /A >nul 2>&1
icacls C:\Windows\Prefetch /grant Administrators:F /T /Q >nul 2>&1
rd /s /q C:\Windows\Prefetch 2>nul
if not exist C:\Windows\Prefetch md C:\Windows\Prefetch >nul 2>&1
if exist C:\Windows\Prefetch (echo   + Prefetch) else (echo   ! Failed to recreate Prefetch)

echo [2/9] Cleaning Windows Temp...
takeown /F C:\Windows\Temp /A >nul 2>&1
icacls C:\Windows\Temp /grant Administrators:F /T /Q >nul 2>&1
rd /s /q C:\Windows\Temp 2>nul
if not exist C:\Windows\Temp md C:\Windows\Temp >nul 2>&1
if exist C:\Windows\Temp (echo   + Windows Temp) else (echo   ! Failed)

echo [3/9] Cleaning Windows Update cache...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
rd /s /q C:\Windows\SoftwareDistribution\Download 2>nul
if not exist C:\Windows\SoftwareDistribution\Download md C:\Windows\SoftwareDistribution\Download >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo   + Windows Update cache

echo [4/9] Cleaning Windows Error Reporting...
rd /s /q C:\ProgramData\Microsoft\Windows\WER 2>nul
if not exist C:\ProgramData\Microsoft\Windows\WER md C:\ProgramData\Microsoft\Windows\WER >nul 2>&1
rd /s /q "%USERPROFILE%\AppData\Local\Microsoft\Windows\WER" 2>nul
if not exist "%USERPROFILE%\AppData\Local\Microsoft\Windows\WER" md "%USERPROFILE%\AppData\Local\Microsoft\Windows\WER" >nul 2>&1
echo   + WER reports

echo [5/9] Cleaning CBS logs...
rd /s /q C:\Windows\Logs\CBS 2>nul
if not exist C:\Windows\Logs\CBS md C:\Windows\Logs\CBS >nul 2>&1
echo   + CBS logs
echo.

:: ============================================
:: User Temp Directories
:: ============================================
echo --- User Temp ---

echo [6/9] Cleaning User Temp...
rd /s /q "%TEMP%" 2>nul
if not exist "%TEMP%" md "%TEMP%" >nul 2>&1
if exist "%TEMP%" (echo   + User Temp) else (echo   ! Failed)

echo [7/9] Cleaning Browser/INet cache...
rd /s /q "%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache" 2>nul
if not exist "%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache" md "%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache" >nul 2>&1
echo   + INetCache

echo [8/10] Cleaning Recent files...
del /f /s /q "%APPDATA%\Microsoft\Windows\Recent\*" >nul 2>&1
echo   + Recent items
echo.

:: ============================================
:: Crash dumps
:: ============================================
echo --- Crash Dumps ---

echo [9/10] Cleaning crash dumps...
rd /s /q "%USERPROFILE%\AppData\Local\CrashDumps" 2>nul
if not exist "%USERPROFILE%\AppData\Local\CrashDumps" md "%USERPROFILE%\AppData\Local\CrashDumps" >nul 2>&1
echo   + CrashDumps
echo.

:: ============================================
:: Recycle Bin
:: ============================================
echo [10/10] Cleaning Recycle Bin...
rd /s /q C:\$Recycle.Bin 2>nul
echo   + All users' Recycle Bin emptied
echo.

:: ============================================
:: Done
:: ============================================
echo ============================================
echo   Cleanup complete.
echo   A reboot is recommended.
echo ============================================
timeout /t 5 >nul
