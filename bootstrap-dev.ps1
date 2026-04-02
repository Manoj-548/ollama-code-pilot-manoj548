# Bootstrap for Ollama Code Pilot dev environment

$workspace = "C:\Users\manoj\Desktop\ollama-code-pilot-manoj548"
Set-Location $workspace

Write-Host "Ensuring .venv exists and dependencies are installed..." -ForegroundColor Cyan
if (-not (Test-Path "$workspace\.venv")) {
    python -m venv .venv
}
.venv\Scripts\python.exe -m pip install -U pip
if (Test-Path "requirements.txt") {
    .venv\Scripts\python.exe -m pip install -r requirements.txt
}

Write-Host "Installing Node deps..." -ForegroundColor Cyan
npm install

Write-Host "Compiling extension..." -ForegroundColor Cyan
npm run compile

Write-Host "Starting FastAPI server in background..." -ForegroundColor Cyan
Start-Process -NoNewWindow -FilePath ".venv\\Scripts\\python.exe" -ArgumentList "-m uvicorn fastapi_server:app --reload --host 0.0.0.0 --port 8000"

Write-Host "Done. Run VS Code now with: code ." -ForegroundColor Green
Write-Host "FastAPI proxy available at http://localhost:8000" -ForegroundColor Green
Write-Host "Ollama health check: http://localhost:8000/health" -ForegroundColor Green
