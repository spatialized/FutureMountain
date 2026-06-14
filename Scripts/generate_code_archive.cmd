@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "SCRIPT=%SCRIPT_DIR%generate_code_archive.sh"
set "BASH_EXE="

where bash >nul 2>nul
if not errorlevel 1 (
    set "BASH_EXE=bash"
)

if not defined BASH_EXE if exist "C:\Program Files\Git\bin\bash.exe" (
    set "BASH_EXE=C:\Program Files\Git\bin\bash.exe"
)

if not defined BASH_EXE if exist "C:\Program Files\Git\usr\bin\bash.exe" (
    set "BASH_EXE=C:\Program Files\Git\usr\bin\bash.exe"
)

if not defined BASH_EXE (
    echo [ERROR] bash was not found on PATH.
    echo Install Git for Windows or add Git Bash to PATH, then run this command again.
    exit /b 1
)

"%BASH_EXE%" "%SCRIPT%" %*
exit /b %ERRORLEVEL%
