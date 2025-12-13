@echo off
REM Run Jupyter Notebook with virtual environment

echo ========================================
echo Starting Jupyter Notebook
echo ========================================
echo.

REM Check if venv exists
if not exist "venv\" (
    echo ERROR: Virtual environment not found!
    echo Please run setup_venv.bat first to create the environment.
    echo.
    pause
    exit /b 1
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Start Jupyter Notebook
echo Opening Jupyter Notebook...
echo.
echo The notebook will open in your default browser.
echo Press Ctrl+C in this window to stop the notebook server.
echo.

jupyter notebook receipt_analysis.ipynb

REM Deactivate when done (this won't run until Jupyter is closed)
deactivate
