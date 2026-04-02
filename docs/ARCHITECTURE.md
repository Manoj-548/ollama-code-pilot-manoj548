# Project Structure & Architecture

## Overview
Ollama Code Pilot is a VS Code extension + FastAPI proxy that provides AI-powered code completions using locally-running Ollama LLMs.

## Directory Layout

```
ollama-code-pilot-manoj548/
├── .vscode/                      # VS Code workspace configuration
│   ├── launch.json              # Debug configurations (extension + FastAPI)
│   ├── settings.json            # Workspace settings & auto-restore
│   ├── extensions.json          # Recommended extensions
│   └── tasks.json               # VS Code tasks (build, setup, run)
│
├── src/                         # TypeScript extension source
│   ├── extension.ts             # Extension entry point & activation
│   ├── commands.ts              # Command handlers (complete, selectModel, showStatus)
│   ├── completion_provider.ts   # Inline completion item provider
│   ├── ollama_client.ts         # Ollama API client wrapper
│   ├── models_provider.ts       # Tree view for available models
│   └── status_view_provider.ts  # Webview for status dashboard
│
├── test/                        # Test files
│   ├── suite/                   # Test suite
│   │   ├── completion_provider.test.ts
│   │   ├── commands.test.ts
│   │   ├── extension.test.ts
│   │   ├── models_provider.test.ts
│   │   ├── ollama_client.test.ts
│   │   ├── status_view_provider.test.ts
│   │   └── index.ts
│   ├── helpers/
│   │   └── mock_vscode.ts       # VS Code API mocks
│   ├── unit/
│   │   └── direct_tests.ts
│   └── runTest.ts               # Test runner
│
├── media/                       # Assets
│   ├── icon.png                 # Extension icon
│   ├── status.css               # Sidebar webview styles
│   └── status.js                # Sidebar webview logic
│
├── .github/                     # GitHub workflows
│   └── workflows/
│       └── publish.yml          # Auto-publish to Marketplace
│
├── out/                         # Compiled output (generated)
├── node_modules/                # Node dependencies (generated)
├── .vscode-test/                # Test runner cache (generated)
│
├── fastapi_server.py            # FastAPI proxy for Ollama
├── bootstrap-dev.ps1            # One-command dev environment setup
├── prompt-ai.ps1                # Terminal CLI helper for AI prompts
├── package.json                 # Node project config + scripts
├── package-lock.json            # Node dependency lock
├── requirements.txt             # Python dependencies (FastAPI)
├── tsconfig.json                # TypeScript compiler config
├── .eslintrc.json               # ESLint configuration
├── .c8rc.json                   # Code coverage config
├── .gitignore                   # Git ignore rules
├── .vscodeignore                # VSIX package ignore rules
├── README.md                    # Main documentation (this is outdated)
└── LICENSE                      # Apache 2.0 license
```

## Component Architecture

### 1. Extension (TypeScript/Node.js)
**Entry**: `src/extension.ts`
- Registers inline completion provider
- Initializes Ollama client
- Sets up command handlers
- Manages tree view + sidebar

**Key Classes**:
- `OllamaClient`: REST client to local Ollama `/api/generate`
- `OllamaCompletionProvider`: Implements `InlineCompletionItemProvider`
- `CommandHandler`: Handles VS Code commands
- `ModelTreeProvider`: Tree view data source
- `StatusViewProvider`: Webview sidebar

### 2. FastAPI Proxy (Python)
**Entry**: `fastapi_server.py`
- REST API wrapper around Ollama `/api/generate`
- Endpoint: `POST /complete` with model + prompt
- Health check: `GET /health`
- Runs on `http://0.0.0.0:8000`

### 3. Development Tools
- **bootstrap-dev.ps1**: One-shot setup (venv, deps, compile, run)
- **prompt-ai.ps1**: Terminal CLI for quick AI queries

## Build Configuration

All build configuration is centralized:

| Config | Location | Purpose |
|--------|----------|---------|
| **NPM Scripts** | `package.json` | Extension compilation, lint, test, package |
| **TypeScript** | `tsconfig.json` | TS → JS compilation settings |
| **ESLint** | `.eslintrc.json` | Code quality linting |
| **Coverage** | `.c8rc.json` | Code coverage reporting |
| **VS Code Tasks** | `.vscode/tasks.json` | Composite build workflow |
| **Debug Launch** | `.vscode/launch.json` | Debug configurations |
| **Python Deps** | `requirements.txt` | FastAPI, uvicorn, etc. |

**Entry Point for Build**: 
- `npm run compile` - compiles TS to `out/extension.js`
- `Task: Setup all` - runs full preparation (venv → deps → compile → lint)
- `Task: Setup and Run All` - setup + FastAPI server background

## Configuration & Settings

### Extension Configuration (from `package.json`)
```
ollama.codeCompletion.providerUrl    : http://localhost:11434
ollama.codeCompletion.model          : codellama:7b
ollama.codeCompletion.maxTokens      : 100
ollama.codeCompletion.temperature    : 0.2
ollama.api.authToken                 : (optional)
ollama.telemetry.enabled             : false
```

### Workspace Settings (`.vscode/settings.json`)
```
- window.restoreWindows              : all
- files.hotExit                      : onExitAndWindowClose
- files.autoSave                     : afterDelay (500ms)
- python.defaultInterpreterPath      : .\.venv\Scripts\python.exe
- terminal.integrated.defaultProfile : PowerShell (Ollama)
```

## Data Flow

```
User Types in Editor
    ↓
VS Code → OllamaCompletionProvider.provideInlineCompletionItems()
    ↓
Builds Prompt (context + cursor position)
    ↓
OllamaClient.generateStream()
    ↓
HTTP POST → http://localhost:11434/api/generate
    ↓
Ollama (codellama:7b)
    ↓
Response → Filter + Post-process
    ↓
Display as Inline Completion Item
```

## Development Workflow

1. **First Time Setup**:
   ```powershell
   .\bootstrap-dev.ps1
   code .
   ```

2. **Live Development** (F5):
   - Launch: "Run Extension + FastAPI (Complete Setup)"
   - Triggers `Task: Setup all` (venv, deps, compile, lint)
   - Opens extension host with inline completions
   - FastAPI server runs in background

3. **During Development**:
   - `npm run watch` - TS compiler watches for changes
   - Changes auto-compile
   - Restart extension host (Shift+Ctrl+F5) to see changes

4. **Testing**:
   - `npm test` - Run mocha test suite
   - `npm run test:coverage` - Generate coverage report

5. **Package**:
   - `npm run package` - Creates `.vsix` file for distribution

## Dependencies

### Node.js (Extension)
- `vscode` - VS Code API
- `axios` - HTTP client
- `typescript` - Compiler
- `eslint` - Linter
- `mocha` - Test framework
- `esbuild` - Bundler

### Python (FastAPI Proxy)
- `fastapi` - Web framework
- `uvicorn` - ASGI server
- `httpx` - Async HTTP client
- `pydantic` - Data validation

### External
- **Ollama** - Local LLM inference engine (required)
- **codellama:7b** - Default code completion model

## Extension Activation

Activation Event: `onStartupFinished`
- Fires when VS Code startup completes
- No delay, runs immediately
- Registers all commands, providers, views

## Testing Strategy

- **Unit Tests**: Core logic (`OllamaClient`, `OllamaCompletionProvider`)
- **Integration**: VS Code API mocking via `mock_vscode.ts`
- **E2E**: Manual testing with actual VS Code extension host
- **Coverage**: c8 HTML reporter in `coverage/` folder
