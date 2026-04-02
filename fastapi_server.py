from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import httpx

app = FastAPI(title="Ollama Code Pilot FastAPI Proxy")

OLLAMA_URL = "http://localhost:11434/api/generate"

class AIRequest(BaseModel):
    prompt: str
    model: str = "codellama:7b"
    max_tokens: int = 150
    temperature: float = 0.2

class AIResponse(BaseModel):
    response: str

@app.get("/health")
async def health():
    return {"status": "alive"}

@app.post("/complete", response_model=AIResponse)
async def complete(req: AIRequest):
    body = {
        "model": req.model,
        "prompt": req.prompt,
        "options": {
            "temperature": req.temperature,
            "num_predict": req.max_tokens,
            "stop": ["<EOT>", "\n\n\n", "<PRE>", "<SUF>", "<MID>"]
        },
        "stream": False
    }

    async with httpx.AsyncClient(timeout=30) as client:
        try:
            resp = await client.post(OLLAMA_URL, json=body)
            resp.raise_for_status()
            data = resp.json()
            return {"response": data.get("response", "")}
        except httpx.RequestError as exc:
            raise HTTPException(status_code=503, detail=f"Ollama service unavailable: {exc}")
        except httpx.HTTPStatusError as exc:
            raise HTTPException(status_code=exc.response.status_code, detail=str(exc))
