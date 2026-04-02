# Bootstrap for Ollama Code Pilot dev environment (Cross-platform)

param(
    [switch]$SkipFastAPI,
    [switch]$SkipVSCode
)

# Get the script directory (cross-platform)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Workspace = $ScriptDir

Write-Host "Setting up Ollama Code Pilot development environment..." -ForegroundColor Cyan
Write-Host "Workspace: $Workspace" -ForegroundColor Gray

Set-Location $Workspace

# Check Python availability
$PythonCmd = $null
if (Get-Command python -ErrorAction SilentlyContinue) {
    $PythonCmd = "python"
} elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
    $PythonCmd = "python3"
} else {
    Write-Error "Python is not installed. Please install Python 3.8+ first."
    exit 1
}

Write-Host "Using Python: $PythonCmd" -ForegroundColor Gray

Write-Host "Ensuring virtual environment exists and dependencies are installed..." -ForegroundColor Cyan
if (-not (Test-Path ".venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    & $PythonCmd -m venv .venv
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to create virtual environment"
        exit 1
    }
}

# Install Python dependencies
if (Test-Path "requirements.txt") {
    Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
    & ".venv\Scripts\python.exe" -m pip install -U pip
    & ".venv\Scripts\python.exe" -m pip install -r requirements.txt
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install Python dependencies"
        exit 1
    }
} else {
    Write-Warning "requirements.txt not found, skipping Python dependencies"
}

# Check Node.js availability
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Error "Node.js is not installed. Please install Node.js 16+ first."
    exit 1
}

Write-Host "Installing Node.js dependencies..." -ForegroundColor Cyan
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to install Node.js dependencies"
    exit 1
}

Write-Host "Compiling extension..." -ForegroundColor Cyan
npm run compile
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to compile extension"
    exit 1
}

if (-not $SkipFastAPI) {
    Write-Host "Starting FastAPI server in background..." -ForegroundColor Cyan
    $FastAPIProcess = Start-Process -NoNewWindow -FilePath ".venv\Scripts\python.exe" -ArgumentList "-m uvicorn fastapi_server:app --reload --host 0.0.0.0 --port 8000" -PassThru
    Write-Host "FastAPI server started (PID: $($FastAPIProcess.Id))" -ForegroundColor Green
}

Write-Host "" -ForegroundColor Green
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host "" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Make sure Ollama is running: ollama serve" -ForegroundColor White
if (-not $SkipFastAPI) {
    Write-Host "2. FastAPI proxy is running at http://localhost:8000" -ForegroundColor White
    Write-Host "3. Ollama health check: http://localhost:8000/health" -ForegroundColor White
}
if (-not $SkipVSCode) {
    Write-Host "4. Opening VS Code..." -ForegroundColor White
    code .
}

Write-Host "" -ForegroundColor Green
Write-Host "Happy coding! 🚀" -ForegroundColor Green
