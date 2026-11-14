# ZetHub Digital Marketing OS - Master Startup Script
# Starts MySQL, Render Service, Backend API, and Frontend Dashboard

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "       ZetHub Digital Marketing OS - Startup      " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# 1. Ensure MySQL is running
$mysqld = Get-Process -Name mysqld -ErrorAction SilentlyContinue
if (-not $mysqld) {
    Write-Host "[1/4] Starting XAMPP MySQL Database daemon (port 3306)..." -ForegroundColor Yellow
    $mysqlBin = "D:\xampp_new\mysql\bin\mysqld.exe"
    $mysqlDir = "D:\xampp_new"
    $myIni = "D:\xampp_new\mysql\bin\my.ini"
    if (-not (Test-Path $mysqlBin)) {
        $mysqlBin = "D:\xampp\mysql\bin\mysqld.exe"
        $mysqlDir = "D:\xampp"
        $myIni = "D:\xampp\mysql\bin\my.ini"
    }
    Start-Process -FilePath $mysqlBin `
        -WorkingDirectory $mysqlDir `
        -ArgumentList "--defaults-file=$myIni", "--standalone" `
        -WindowStyle Hidden
    Start-Sleep -Seconds 2
} else {
    Write-Host "[1/4] XAMPP MySQL daemon is already running (PID: $($mysqld.Id))" -ForegroundColor Green
}

# 2. Start Render Service (port 5001)
$pythonw = "D:\marketing_os\.venv\Scripts\pythonw.exe"
Write-Host "[2/4] Starting Brand Image Render Service (port 5001)..." -ForegroundColor Yellow
Start-Process -FilePath $pythonw `
    -WorkingDirectory "D:\marketing_os" `
    -ArgumentList "-m", "uvicorn", "render_service.app:app", "--host", "127.0.0.1", "--port", "5001"

# 3. Start Backend API (port 8000)
Write-Host "[3/4] Starting ZetHub Backend API Server (port 8000)..." -ForegroundColor Yellow
Start-Process -FilePath $pythonw `
    -WorkingDirectory "D:\marketing_os" `
    -ArgumentList "-m", "uvicorn", "backend.app.main:app", "--host", "127.0.0.1", "--port", "8000"

# 4. Start Frontend Dashboard (port 5173)
Write-Host "[4/4] Starting React Admin Dashboard (port 5173)..." -ForegroundColor Yellow
Start-Process -FilePath "cmd.exe" `
    -WorkingDirectory "D:\marketing_os\frontend" `
    -ArgumentList "/c", "npm", "run", "dev" `
    -WindowStyle Minimized

Start-Sleep -Seconds 3

Write-Host "`n==================================================" -ForegroundColor Green
Write-Host "       ZetHub Marketing OS is now ACTIVE!         " -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host "• Admin Dashboard:    http://localhost:5173" -ForegroundColor Cyan
Write-Host "• Backend API & Docs: http://localhost:8000/docs" -ForegroundColor Cyan
Write-Host "• Render Microservice:http://localhost:5001/health" -ForegroundColor Cyan
Write-Host "• Terminal CLI:       python terminal/main.py" -ForegroundColor Cyan
Write-Host "• n8n Engine:         Run scripts\start-n8n.bat (port 5678)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Green

