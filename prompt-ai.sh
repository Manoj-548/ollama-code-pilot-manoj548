#!/bin/bash
# Cross-platform AI prompt script for Linux/Mac

if [ $# -eq 0 ]; then
    echo "Usage: $0 <prompt>"
    echo "Example: $0 'Write a function to calculate fibonacci numbers'"
    exit 1
fi

PROMPT="$1"
PROVIDER="http://localhost:11434/api/generate"

# JSON payload
JSON_PAYLOAD=$(cat <<EOF
{
  "model": "codellama:7b",
  "prompt": "$PROMPT",
  "options": {
    "temperature": 0.2,
    "num_predict": 150
  },
  "stream": false
}
EOF
)

echo "🤖 Asking Ollama..."
echo "Prompt: $PROMPT"
echo ""

# Make the request
RESPONSE=$(curl -s -X POST "$PROVIDER" \
    -H "Content-Type: application/json" \
    -d "$JSON_PAYLOAD")

# Check if curl succeeded
if [ $? -ne 0 ]; then
    echo "❌ Failed to connect to Ollama. Is it running?"
    echo "Start Ollama with: ollama serve"
    exit 1
fi

# Extract response
RESPONSE_TEXT=$(echo "$RESPONSE" | jq -r '.response // empty')

if [ -z "$RESPONSE_TEXT" ]; then
    echo "❌ No response received from Ollama"
    echo "Raw response: $RESPONSE"
    exit 1
fi

echo "✅ Response:"
echo "$RESPONSE_TEXT"