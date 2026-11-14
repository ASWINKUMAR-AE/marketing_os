# ZetHub Digital Marketing OS - Health Check Script
Write-Host "=== ZetHub Marketing OS System Diagnostic ===" -ForegroundColor Cyan

# 1. Check MySQL
try {
    $mysqlVer = & "D:\xampp\mysql\bin\mysql.exe" -u root -e "SELECT VERSION();" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] MySQL 3306: ONLINE ($($mysqlVer[1]))" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] MySQL 3306: OFFLINE" -ForegroundColor Red
    }
} catch {
    Write-Host "[FAIL] MySQL check error: $_" -ForegroundColor Red
}

# 2. Check Backend API (8000)
try {
    $res = Invoke-RestMethod -Uri "http://127.0.0.1:8000/api/health" -TimeoutSec 3
    Write-Host "[OK] Backend API 8000: ONLINE (status: $($res.status), company: $($res.company))" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Backend API 8000: Not responding (start with scripts\start.ps1)" -ForegroundColor Yellow
}

# 3. Check Render Service (5001)
try {
    $res = Invoke-RestMethod -Uri "http://127.0.0.1:5001/health" -TimeoutSec 3
    Write-Host "[OK] Render Service 5001: ONLINE (service: $($res.service))" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Render Service 5001: Not responding (start with scripts\start.ps1)" -ForegroundColor Yellow
}

# 4. Check Frontend (5173)
try {
    $res = Invoke-WebRequest -Uri "http://127.0.0.1:5173" -TimeoutSec 3
    Write-Host "[OK] Frontend Dashboard 5173: ONLINE" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Frontend Dashboard 5173: Not running (start with scripts\start.ps1)" -ForegroundColor Yellow
}

# 5. Check Vireonix AI API
try {
    $body = @{ model = "auto"; messages = @(@{ role = "user"; content = "Respond with 'OK'" }) } | ConvertTo-Json
    $res = Invoke-RestMethod -Uri "https://vireonix.ai/v1/chat/completions" -Method POST -ContentType "application/json" -Body ([Text.Encoding]::UTF8.GetBytes($body)) -TimeoutSec 10
    Write-Host "[OK] Vireonix AI Gateway: ONLINE (Model: auto)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Vireonix AI Gateway: OFFLINE ($($_.Exception.Message))" -ForegroundColor Red
}

# 6. Disk Space Check
$dDrive = Get-PSDrive D
$freeGB = [math]::Round($dDrive.Free / 1GB, 2)
Write-Host "[OK] Storage on D: Drive: $freeGB GB Free" -ForegroundColor Green

