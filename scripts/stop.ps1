# ZetHub Digital Marketing OS - Shutdown Script
Write-Host "Stopping ZetHub Marketing OS background services..." -ForegroundColor Yellow

# Stop uvicorn python processes
Get-Process -Name python -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -like "*D:\marketing_os\.venv*"
} | Stop-Process -Force -ErrorAction SilentlyContinue

# Stop node processes running frontend
Get-Process -Name node -ErrorAction SilentlyContinue | Where-Object {
    $_.CommandLine -like "*vite*" -or $_.CommandLine -like "*marketing_os*"
} | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "ZetHub services stopped successfully." -ForegroundColor Green

