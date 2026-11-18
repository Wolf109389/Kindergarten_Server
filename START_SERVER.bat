@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
title Kindergarten Server - Lab 4 Variant 34

if exist ".venv\Scripts\python.exe" goto dependencies
py -3 -c "import sys; sys.exit(sys.version_info < (3,10))" >nul 2>&1
if not errorlevel 1 (
    py -3 -m venv .venv
    if errorlevel 1 goto failed
    goto dependencies
)
python -c "import sys; sys.exit(sys.version_info < (3,10))" >nul 2>&1
if errorlevel 1 (
    echo Python 3.10 or newer is required. Install Python, then run this file again.
    pause
    exit /b 1
)
python -m venv .venv
if errorlevel 1 goto failed

:dependencies
if exist ".venv\.deps_ready" goto run
echo Installing Python dependencies. Internet is needed on the first run.
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto failed
type nul > ".venv\.deps_ready"

:run
".venv\Scripts\python.exe" -X utf8 bootstrap.py %*
if errorlevel 1 goto failed
goto done

:failed
echo.
echo Startup failed. Read the message above and README_UA.md.
:done
pause
