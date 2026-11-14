param(
    [Parameter(Mandatory=$false)]
    [string]$Prompt = "Create 3 LinkedIn post hooks for ZetHub AI automation targeting Indian SMEs",

    [Parameter(Mandatory=$false)]
    [string]$System = "You are ZetHub's digital marketing AI strategist."
)

$body = @{
    model = "auto"
    messages = @(
        @{ role = "system"; content = $System },
        @{ role = "user"; content = $Prompt }
    )
} | ConvertTo-Json -Depth 5

try {
    $r = Invoke-RestMethod -Uri "https://vireonix.ai/v1/chat/completions" `
         -Method POST -ContentType "application/json; charset=utf-8" `
         -Body ([Text.Encoding]::UTF8.GetBytes($body)) -TimeoutSec 45

    Write-Host "`n=== Vireonix AI Response ===" -ForegroundColor Cyan
    $r.choices[0].message.content
} catch {
    Write-Error "Vireonix API Error: $_"
}

