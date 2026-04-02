@echo off
setlocal enabledelayedexpansion

echo 🔧 Setting up Ollama Code Pilot for Windows...
echo.

REM Get the script directory
set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR:~0,-1%"

echo 📁 Project root: %PROJECT_ROOT%

REM Check Python availability
where python >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Python is not installed. Please install Python 3.8+ first.
    pause
    exit /b 1
)

set PYTHON_CMD=python
echo 🐍 Using Python: %PYTHON_CMD%

REM Create virtual environment
echo 📦 Creating virtual environment...
if not exist ".venv" (
    %PYTHON_CMD% -m venv .venv
) else (
    echo ✅ Virtual environment already exists
)

REM Install Python dependencies
echo 📚 Installing Python dependencies...
if exist "requirements.txt" (
    .venv\Scripts\python.exe -m pip install -U pip
    .venv\Scripts\python.exe -m pip install -r requirements.txt
) else (
    echo ⚠️  requirements.txt not found
)

REM Check Node.js availability
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js 16+ first.
    pause
    exit /b 1
)

echo 📦 Installing Node.js dependencies...
call npm install

echo 🔨 Compiling extension...
call npm run compile

echo.
echo ✅ Setup complete!
echo.
echo 🎯 Next steps:
echo 1. Start Ollama: ollama serve
echo 2. Start FastAPI server: .venv\Scripts\python.exe -m uvicorn fastapi_server:app --reload --host 0.0.0.0 --port 8000
echo 3. Open VS Code: code .
echo.
echo 🌐 Services:
echo    - Ollama API: http://localhost:11434
echo    - FastAPI Proxy: http://localhost:8000
echo    - Health Check: http://localhost:8000/health
echo.
echo 📚 Documentation: See README.md for detailed usage instructions
echo.
echo Happy coding! 🚀
echo.
pause