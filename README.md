# Ollama Code Pilot

**AI-Powered Code Completions for VS Code using Local Ollama**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)
![Node](https://img.shields.io/badge/Node-v20+-green)
![Python](https://img.shields.io/badge/Python-3.8+-blue)

## 🚀 Quick Start (One Command)

### Prerequisites
- [Ollama](https://ollama.ai/) installed and running: `ollama serve`
- Python 3.8+ and Node.js 20+
- VS Code 1.74+

### Run Setup
```powershell
cd ollama-code-pilot-manoj548
.\bootstrap-dev.ps1
code .
```

Then press **F5** → Select **"Run Extension + FastAPI (Complete Setup)"**

✅ That's it! Everything auto-configures:
- Python venv + dependencies
- Node packages
- Extension compilation
- Code linting
- FastAPI server (background)
- VS Code extension host

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| **[SETUP.md](./docs/SETUP.md)** | 📖 Complete setup guide, config options, troubleshooting |
| **[ARCHITECTURE.md](./docs/ARCHITECTURE.md)** | 🏗️ Project structure, components, data flow |
| **[ACHIEVEMENTS.md](./docs/ACHIEVEMENTS.md)** | 🎯 Features, milestones, technical details |

---

## ✨ Features

- ✅ **Inline Code Completions**: AI suggestions as you type
- ✅ **Local Processing**: Everything runs on your machine (no cloud)
- ✅ **FastAPI Backend**: REST API wrapper for extensibility
- ✅ **Terminal Helper**: `./prompt-ai.ps1 -q "..."`
- ✅ **Model Management**: Switch models from VS Code UI
- ✅ **Status Monitoring**: Real-time Ollama connection status
- ✅ **One-Command Setup**: Fully automated environment
- ✅ **Comprehensive Docs**: Architecture, setup, troubleshooting
- ✅ **No Duplicates**: Unified build configuration
- ✅ **Live Reload**: Watch mode for development

---

## 🔧 Available Commands

### VS Code (Ctrl+Shift+P)
- `Ollama: Complete with Model` - Generate completion
- `Ollama: Select Model` - Change default model  
- `Ollama: Show Status` - Check Ollama status
- `Ollama: Refresh Models` - Reload model list

### Debug (F5)
- **Run Extension** - Standard debug mode
- **Extension Tests** - Run test suite
- **FastAPI Server** - Debug Python backend
- **Run Extension + FastAPI** ⭐ - Full stack with auto-setup

### Tasks (Ctrl+Shift+B)
- **Setup all** - Prepare environment (venv → deps → compile → lint)
- **Setup and Run All** - Setup + start FastAPI
- **Build extension** - Compile TypeScript only
- **Run FastAPI server** - Start REST API server

---

## 🗂️ Project Structure

```
src/                        # TypeScript extension
  ├── extension.ts         # Entry point
  ├── completion_provider.ts    # Inline completions
  ├── ollama_client.ts     # Ollama API wrapper
  ├── commands.ts          # Command handlers
  ├── models_provider.ts   # Model tree view
  └── status_view_provider.ts   # Status sidebar

fastapi_server.py          # REST API proxy
prompt-ai.ps1             # Terminal AI helper
bootstrap-dev.ps1         # One-command setup

docs/
  ├── SETUP.md            # Setup guide + troubleshooting
  ├── ARCHITECTURE.md     # Structure + design
  └── ACHIEVEMENTS.md     # Milestones + features

.vscode/
  ├── launch.json         # Debug configurations
  ├── tasks.json          # Build tasks  
  └── settings.json       # Workspace settings
```

See [ARCHITECTURE.md](./docs/ARCHITECTURE.md) for full structure.

---

## ⚙️ Configuration

### Ollama Settings
In VS Code → Settings → search "ollama":

| Setting | Default | Description |
|---------|---------|-------------|
| `providerUrl` | `http://localhost:11434` | Ollama API endpoint |
| `model` | `codellama:7b` | Default model |
| `maxTokens` | `100` | Max tokens to generate |
| `temperature` | `0.2` | Creativity (0.0-1.0) |

### Available Models
```powershell
# Check installed:
curl http://localhost:11434/api/tags

# Install new:
ollama pull codellama:13b
```

**Recommended**:
- `codellama:7b` (Fast, 7B params) ⭐
- `codellama:13b` (More accurate)
- `mistral` (Fast, general)

See [SETUP.md](./docs/SETUP.md) for all settings.

---

## 🐛 Troubleshooting

### Ollama not running?
```powershell
ollama serve
# Then: ollama pull codellama:7b
```

### Extension won't compile?
```powershell
npm install
npm run check-types  # See TypeScript errors
```

### FastAPI not starting?
```powershell
.venv\Scripts\python.exe -m uvicorn fastapi_server:app --host 0.0.0.0 --port 8000
```

### Tests failing?
```powershell
npm test
npm run test:coverage  # See coverage report
```

**Full troubleshooting guide**: [SETUP.md #Troubleshooting](./docs/SETUP.md#troubleshooting)

---

## 🧪 Testing

```powershell
npm test              # Run mocha test suite
npm run test:coverage # Generate HTML coverage report
npm run lint          # Check code style
npm run check-types   # TypeScript validation
```

Test coverage: 30%+ (unit + integration)

---

## 📦 Build & Package

### Development Build
```powershell
npm run compile       # Single compile
npm run watch         # Auto-recompile on changes
```

### Production Packaging
```powershell
npm run package       # Creates .vsix file
# or
npm run vscode:prepublish  # Pre-publish hook
```

### Publish to Marketplace
```powershell
vsce login            # Auth to marketplace
vsce publish          # Publish to VS Code Marketplace
```

---

## 🔌 API Reference

### FastAPI (`http://localhost:8000`)
```powershell
# Health check
GET /health

# Generate completion
POST /complete
Body: {
  "prompt": "function hello() {",
  "model": "codellama:7b",
  "max_tokens": 150,
  "temperature": 0.2
}
```

### Ollama (Upstream)
```powershell
# List models
GET http://localhost:11434/api/tags

# Generate completion
POST http://localhost:11434/api/generate
```

---

## 👥 Development

### Contribution Welcome!
- Fork the repo
- Create feature branch
- Follow [ARCHITECTURE.md](./docs/ARCHITECTURE.md) conventions
- Run `npm test && npm run lint` before commit
- Submit PR

### Code Style
- ESLint + TypeScript strict mode
- Async/await (no callbacks)
- Proper error handling
- JSDoc comments on public methods

---

## 📊 Project Status

| Area | Status |
|------|--------|
| Extension | ✅ Production Ready |
| FastAPI Backend | ✅ Production Ready |
| Documentation | ✅ Comprehensive |
| Tests | ✅ 30%+ coverage |
| Build System | ✅ Zero duplicates |
| Terminal Helper | ✅ Working |
| Auto-Setup | ✅ One-command |

---

## 📄 License

Apache License 2.0 - See [LICENSE](./LICENSE)

---

## 🎯 Next Steps

1. **First Time**: Read [SETUP.md](./docs/SETUP.md)
2. **Architecture**: See [ARCHITECTURE.md](./docs/ARCHITECTURE.md)  
3. **Contributing**: Check [ACHIEVEMENTS.md](./docs/ACHIEVEMENTS.md)

---

## 🔗 Links

- 📖 [Setup Guide](./docs/SETUP.md)
- 🏗️ [Architecture Guide](./docs/ARCHITECTURE.md)
- 🎯 [Achievements & Milestones](./docs/ACHIEVEMENTS.md)
- 🐛 [Ollama](https://ollama.ai/)
- 💻 [VS Code API](https://code.visualstudio.com/api)
- 🚀 [FastAPI](https://fastapi.tiangolo.com/)

---

**Made with ❤️ for local AI**
