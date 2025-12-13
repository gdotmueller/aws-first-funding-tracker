@echo off
REM Setup virtual environment for receipt analysis

echo ========================================
echo Receipt Analysis - Virtual Environment Setup
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8 or higher from https://www.python.org/
    pause
    exit /b 1
)

REM Check if venv already exists
if exist "venv\" (
    echo Virtual environment already exists.
    echo.
    choice /C YN /M "Do you want to recreate it"
    if errorlevel 2 goto :activate
    echo Removing old virtual environment...
    rmdir /s /q venv
)

REM Create virtual environment
echo Creating virtual environment...
python -m venv venv
if errorlevel 1 (
    echo ERROR: Failed to create virtual environment
    pause
    exit /b 1
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

REM Upgrade pip
echo Upgrading pip...
python -m pip install --upgrade pip

REM Install requirements
echo Installing required packages...
pip install -r requirements.txt

echo.
echo ========================================
echo Setup complete!
echo ========================================
echo.
echo To activate the virtual environment in the future, run:
echo     venv\Scripts\activate.bat
echo.
echo To run the Jupyter notebook, run:
echo     run_notebook.bat
echo.

:activate
echo The virtual environment is ready at: venv\
echo.
pause
