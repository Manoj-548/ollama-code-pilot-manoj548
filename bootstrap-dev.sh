#!/bin/bash
# Bootstrap for Ollama Code Pilot dev environment (Linux/Mac)

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$SCRIPT_DIR"

echo "Setting up Ollama Code Pilot development environment..."
echo "Workspace: $WORKSPACE"

cd "$WORKSPACE"

# Check if Python is available
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "❌ Python is not installed. Please install Python 3.8+ first."
    exit 1
fi

# Use python3 if available, otherwise python
PYTHON_CMD="python3"
if ! command -v python3 &> /dev/null; then
    PYTHON_CMD="python"
fi

echo "Ensuring virtual environment exists and dependencies are installed..."
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    "$PYTHON_CMD" -m venv .venv
fi

# Activate virtual environment and install dependencies
if [ -f "requirements.txt" ]; then
    echo "Installing Python dependencies..."
    .venv/bin/python -m pip install -U pip
    .venv/bin/python -m pip install -r requirements.txt
else
    echo "⚠️  requirements.txt not found, skipping Python dependencies"
fi

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 16+ first."
    exit 1
fi

echo "Installing Node.js dependencies..."
npm install

echo "Compiling extension..."
npm run compile

echo "✅ Setup complete!"
echo ""
echo "To start the development environment:"
echo "1. Start Ollama: ollama serve"
echo "2. Start FastAPI server: .venv/bin/python -m uvicorn fastapi_server:app --reload --host 0.0.0.0 --port 8000"
echo "3. Open VS Code: code ."
echo ""
echo "FastAPI proxy will be available at http://localhost:8000"
echo "Ollama health check: http://localhost:8000/health"