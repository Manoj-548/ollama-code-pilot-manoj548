param(
  [Parameter(Mandatory=$true, HelpMessage="The prompt to send to Ollama")]
  [string]$q,

  [Parameter(Mandatory=$false, HelpMessage="Model to use (default: codellama:7b)")]
  [string]$Model = "codellama:7b",

  [Parameter(Mandatory=$false, HelpMessage="Temperature for generation (default: 0.2)")]
  [double]$Temperature = 0.2,

  [Parameter(Mandatory=$false, HelpMessage="Maximum tokens to generate (default: 150)")]
  [int]$MaxTokens = 150,

  [Parameter(Mandatory=$false, HelpMessage="Ollama server URL")]
  [string]$Provider = "http://localhost:11434/api/generate"
)

Write-Host "🤖 Asking Ollama..." -ForegroundColor Cyan
Write-Host "Prompt: $q" -ForegroundColor Gray
Write-Host "Model: $Model | Temperature: $Temperature | Max Tokens: $MaxTokens" -ForegroundColor Gray
Write-Host ""

$body = @{
  model = $Model
  prompt = $q
  options = @{
    temperature = $Temperature
    num_predict = $MaxTokens
  }
  stream = $false
} | ConvertTo-Json -Depth 5

try {
  $response = Invoke-RestMethod -Uri $Provider -Method Post -Body $body -ContentType 'application/json' -ErrorAction Stop

  if ($null -ne $response.response -and $response.response.Trim() -ne "") {
    Write-Host "✅ Response:" -ForegroundColor Green
    Write-Host $response.response -ForegroundColor White
  } else {
    Write-Warning "No response text received from Ollama"
    Write-Host "Raw response:" -ForegroundColor Yellow
    $response | ConvertTo-Json | Write-Host
  }
} catch {
  Write-Error "AI request failed: $($_.Exception.Message)"

  if ($_.Exception.Response) {
    Write-Host "HTTP Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    Write-Host "HTTP Response:" -ForegroundColor Red
    try {
      $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
      $responseBody = $reader.ReadToEnd()
      $reader.Close()
      Write-Host $responseBody -ForegroundColor Red
    } catch {
      Write-Host "Could not read response body" -ForegroundColor Red
    }
  }

  Write-Host ""
  Write-Host "Troubleshooting:" -ForegroundColor Yellow
  Write-Host "1. Make sure Ollama is running: ollama serve" -ForegroundColor White
  Write-Host "2. Check if the model is available: ollama list" -ForegroundColor White
  Write-Host "3. Verify the server URL: $Provider" -ForegroundColor White
  exit 1
}
