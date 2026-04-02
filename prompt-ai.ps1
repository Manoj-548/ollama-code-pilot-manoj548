param(
  [Parameter(Mandatory=$true)]
  [string]$q
)

$provider = "http://localhost:11434/api/generate"
$body = @{
  model = "codellama:7b"
  prompt = $q
  options = @{ temperature = 0.2; num_predict = 150 }
  stream = $false
} | ConvertTo-Json -Depth 5

try {
  $response = Invoke-RestMethod -Uri $provider -Method Post -Body $body -ContentType 'application/json' -ErrorAction Stop
  if ($null -ne $response.response) {
    Write-Host $response.response -ForegroundColor Green
  } else {
    Write-Warning "No response text received"
  }
} catch {
  Write-Error "AI request failed: $($_.Exception.Message)"
}
