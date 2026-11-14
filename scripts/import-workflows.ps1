# Import n8n Workflows Script for ZetHub Marketing OS
param(
    [string]$N8nUrl = "http://localhost:5678/api/v1",
    [string]$ApiKey = ""
)

if (-not $ApiKey) {
    # Check .env
    if (Test-Path "D:\marketing_os\.env") {
        Get-Content "D:\marketing_os\.env" | ForEach-Object {
            if ($_ -match "^N8N_API_KEY=(.+)$") {
                $ApiKey = $matches[1].Trim()
            }
        }
    }
}

$workflowFiles = Get-ChildItem -Path "D:\marketing_os\workflows" -Filter "*.json"
Write-Host "Found $($workflowFiles.Count) workflow files to import." -ForegroundColor Cyan

if (-not $ApiKey) {
    Write-Host "`n[NOTE] N8N_API_KEY is not set in .env or arguments." -ForegroundColor Yellow
    Write-Host "You can import workflows into n8n in two ways:" -ForegroundColor Cyan
    Write-Host "  1. Direct in n8n UI: Open http://localhost:5678 -> Workflows -> Import from File (Select each file in D:\marketing_os\workflows)"
    Write-Host "  2. Via API: Generate API key in n8n Settings -> n8n API, paste in .env as N8N_API_KEY, and re-run this script."
    exit 0
}

$headers = @{
    "X-N8N-API-KEY" = $ApiKey
    "Content-Type" = "application/json"
}

foreach ($wf in $workflowFiles) {
    Write-Host "Importing $($wf.Name)..." -NoNewline
    try {
        $content = Get-Content $wf.FullName -Raw -Encoding UTF8
        $response = Invoke-RestMethod -Uri "$N8nUrl/workflows" -Method POST -Headers $headers -Body $content
        Write-Host " [OK] (ID: $($response.id))" -ForegroundColor Green
    } catch {
        Write-Host " [FAIL: $_]" -ForegroundColor Red
    }
}

