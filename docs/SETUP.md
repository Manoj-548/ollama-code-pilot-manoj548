# Setup Guide - Ollama Code Pilot

## Quick Start (One Command)

### Prerequisites
- [Ollama](https://ollama.ai/) installed and running
- Python 3.8+
- Node.js 20+
- VS Code 1.74+

### Step 1: Start Ollama Service
```powershell
ollama serve
# or if codellama:7b is not installed:
ollama pull codellama:7b
ollama serve
```

### Step 2: Run Bootstrap Setup
```powershell
cd C:\Users\manoj\Desktop\ollama-code-pilot-manoj548
.\bootstrap-dev.ps1
```

This single command:
1. ✅ Creates Python virtual environment (`.venv`)
2. ✅ Installs FastAPI + dependencies
3. ✅ Installs Node.js packages (`npm install`)
4. ✅ Compiles TypeScript extension
5. ✅ Starts FastAPI proxy on `http://localhost:8000`
6. ✅ Prints ready message

### Step 3: Open VS Code
```powershell
code .
```

### Step 4: Select Debug Configuration
1. Press **F5** (or Ctrl+Shift+D → Run)
2. Select: **"Run Extension + FastAPI (Complete Setup)"**
3. Watch terminal for auto-setup steps
4. VS Code extension host launches
5. Extension is active with inline completions

---

## Manual Setup Steps (if bootstrap doesn't work)

### 1. Create Python Virtual Environment
```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

### 2. Install Python Dependencies
```powershell
pip install --upgrade pip
pip install -r requirements.txt
```

### 3. Install Node Dependencies
```powershell
npm install
```

### 4. Compile TypeScript
```powershell
npm run compile
```

### 5. Start FastAPI Server (Background)
```powershell
.venv\Scripts\python.exe -m uvicorn fastapi_server:app --reload --host 0.0.0.0 --port 8000
```

### 6. Start VS Code Extension
```powershell
code .
# Then press F5 → "Run Extension" (or "Run Extension + FastAPI")
```

---

## Configuration

### Ollama Settings (VS Code Settings)
Open **File → Preferences → Settings** and search for `ollama`:

| Setting | Default | Description |
|---------|---------|-------------|
| `ollama.codeCompletion.providerUrl` | `http://localhost:11434` | Ollama API URL |
| `ollama.codeCompletion.model` | `codellama:7b` | Model to use |
| `ollama.codeCompletion.maxTokens` | `100` | Max tokens to generate |
| `ollama.codeCompletion.temperature` | `0.2` | Creativity (0.0-1.0) |
| `ollama.codeCompletion.triggerCharacters` | `['.', ' ', '(', '[', '{']` | Auto-trigger chars |
| `ollama.api.authToken` | (empty) | Optional auth token |

### Available Models
Check in VS Code → Ollama Code Pilot sidebar view, or:
```powershell
curl http://localhost:11434/api/tags
```

Popular code completion models:
- `codellama:7b` (Fast, 7B params) ⭐ Default
- `codellama:13b` (Accurate, 13B params)
- `mistral` (Fast, general purpose)

### Terminal AI Helper (Optional)
Use `prompt-ai.ps1` to query Ollama from terminal:

```powershell
.\prompt-ai.ps1 -q "Write a function to reverse a string in JavaScript"
```

Or add alias to PowerShell profile:
```powershell
# Add to $PROFILE
Set-Alias prompt-ai C:\Users\manoj\Desktop\ollama-code-pilot-manoj548\prompt-ai.ps1
# Then: prompt-ai -q "..."
```

---

## Available Commands in VS Code

### Commands (Ctrl+Shift+P)
- **Ollama: Complete with Model** - Generate completion
- **Ollama: Select Model** - Change default model
- **Ollama: Show Status** - Check Ollama connection
- **Ollama: Refresh Models** - Reload model list

### Status Bar
Click the Ollama status in status bar (bottom right) to see health and current model.

### Sidebar
Open "Ollama Code Pilot" in activity bar to see:
- Service status (connected/offline)
- Current model
- Available models list
- API URL

---

## Available Tasks

Press **Ctrl+Shift+B** to open task menu:

| Task | Purpose |
|------|---------|
| **Init Python venv** | Create `.venv` with pip |
| **Install Node deps** | `npm install` |
| **Build extension** | Compile TS (depends on Node deps + venv) |
| **Lint code** | ESLint check |
| **Setup all** | Run all above sequentially |
| **Setup and Run All** | Setup + start FastAPI |
| **Run FastAPI server** | Start FastAPI on :8000 |
| **npm watch** | Watch TS, auto-compile |

---

## Debug Configurations

Press **F5** → Select from list:

| Config | Purpose |
|--------|---------|
| **Run Extension** | Launch extension with default build task |
| **Extension Tests** | Run mocha test suite |
| **FastAPI Server** | Debug FastAPI with Python debugger |
| **Run Extension + FastAPI (Complete Setup)** | ⭐ Full stack (runs "Setup all" first) |

---

## Troubleshooting

### "Ollama service is not running"
1. Check if Ollama is running: `ollama serve` (in another terminal)
2. Verify endpoint is reachable: `curl http://localhost:11434/api/tags`
3. In VS Code settings, change `ollama.codeCompletion.providerUrl` if Ollama is on different host/port

### "No models found"
```powershell
# Pull a model first:
ollama pull codellama:7b
# Restart VS Code or run "Ollama: Refresh Models"
```

### FastAPI not starting
```powershell
# Manual test:
.venv\Scripts\python.exe -m uvicorn fastapi_server:app --host 0.0.0.0 --port 8000
# Should see: "Uvicorn running on http://0.0.0.0:8000"
```

### Extension not compiling
```powershell
npm install
npm run compile
# Check for TS errors
npm run check-types
```

### Tests failing
```powershell
npm test
# Run with coverage:
npm run test:coverage
# Open coverage/index.html in browser
```

---

## Development Workflow

### Editor Setup
1. Open project in VS Code: `code .`
2. Install recommended extensions (prompt appears)
3. Create `.venv`: Run **Task: Init Python venv**
4. Install deps: Run **Task: Install Node deps**
5. (Optional) Start FastAPI: Run **Task: Run FastAPI server**

### Live Coding
1. Terminal → **npm run watch** (watches TS files)
2. Edit `src/` files
3. Changes auto-compile to `out/`
4. In VS Code extension host: **Shift+Ctrl+F5** to reload

### Testing
```powershell
npm test                # Run all tests
npm run test:coverage   # Generate coverage
npm run lint           # Check code style
```

### Publishing
```powershell
npm run package        # Creates .vsix file
# For Marketplace:
vsce login
vsce publish           # Requires credentials
```

---

## API Endpoints

### Ollama (local)
- **GET** `http://localhost:11434/` - Health check
- **GET** `http://localhost:11434/api/tags` - List models
- **POST** `http://localhost:11434/api/generate` - Generate completion

### FastAPI Proxy
- **GET** `http://localhost:8000/health` - Server status
- **POST** `http://localhost:8000/complete` - Generate completion via proxy

**Example request** (FastAPI):
```curl
curl -X POST http://localhost:8000/complete \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "function reverse(str) {",
    "model": "codellama:7b",
    "max_tokens": 150,
    "temperature": 0.2
  }'
```

---

## File Locations

| What | Path |
|------|------|
| Extension code | `src/` |
| Tests | `test/` |
| Compiled output | `out/extension.js` |
| VS Code config | `.vscode/` |
| Python FastAPI | `fastapi_server.py` |
| Python deps | `requirements.txt` |
| Node deps | `package.json`, `package-lock.json` |
| Config files | `.eslintrc.json`, `tsconfig.json`, `.c8rc.json` |
| Build scripts | `bootstrap-dev.ps1`, `prompt-ai.ps1` |
| Docs | `docs/` |

---

## Next Steps

- Read [ARCHITECTURE.md](./ARCHITECTURE.md) for deep dive into codebase
- Check [ACHIEVEMENTS.md](./ACHIEVEMENTS.md) for project milestones
- Review [project structure diagram](#) (in ARCHITECTURE.md)
- Explore test files in `test/` for examples
