#!/bin/bash
# Universal setup script for Ollama Code Pilot
# Works on Linux, macOS, and Windows (with WSL/Git Bash)

set -e

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo "🔧 Detected OS: $OS"
echo "🚀 Setting up Ollama Code Pilot..."
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

echo "📁 Project root: $PROJECT_ROOT"

# Check Python availability
PYTHON_CMD=""
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "❌ Python is not installed. Please install Python 3.8+ first."
    exit 1
fi

echo "🐍 Using Python: $PYTHON_CMD"

# Create virtual environment
echo "📦 Creating virtual environment..."
if [ ! -d ".venv" ]; then
    "$PYTHON_CMD" -m venv .venv
else
    echo "✅ Virtual environment already exists"
fi

# Activate and setup Python dependencies
echo "📚 Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    .venv/bin/python -m pip install -U pip
    .venv/bin/python -m pip install -r requirements.txt
else
    echo "⚠️  requirements.txt not found"
fi

# Check Node.js availability
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 16+ first."
    exit 1
fi

echo "📦 Installing Node.js dependencies..."
npm install

echo "🔨 Compiling extension..."
npm run compile

echo ""
echo "✅ Setup complete!"
echo ""
echo "🎯 Next steps:"
echo "1. Start Ollama: ollama serve"
echo "2. Start FastAPI server: .venv/bin/python -m uvicorn fastapi_server:app --reload --host 0.0.0.0 --port 8000"
echo "3. Open VS Code: code ."
echo ""
echo "🌐 Services:"
echo "   - Ollama API: http://localhost:11434"
echo "   - FastAPI Proxy: http://localhost:8000"
echo "   - Health Check: http://localhost:8000/health"
echo ""
echo "📚 Documentation: See README.md for detailed usage instructions"
echo ""
echo "Happy coding! 🚀"