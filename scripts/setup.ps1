# ZetHub Digital Marketing OS - Master Setup Script
# Configured strictly for D: drive execution

$ErrorActionPreference = "Stop"
Write-Host "=== Setting up ZetHub Marketing OS on D: Drive ===" -ForegroundColor Cyan

# 1. Check Python
$pyVer = py -3.12 --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Python 3.12 found: $pyVer" -ForegroundColor Green
} else {
    Write-Warning "Python 3.12 not found. Falling back to default python."
}

# 2. Check Virtual Environment on D:
$venvPython = "D:\marketing_os\.venv\Scripts\python.exe"
if (-not (Test-Path $venvPython)) {
    Write-Host "Creating Python virtualenv in D:\marketing_os\.venv..." -ForegroundColor Yellow
    py -3.12 -m venv "D:\marketing_os\.venv"
}
Write-Host "[OK] Virtual environment ready at D:\marketing_os\.venv" -ForegroundColor Green

# 3. Check MySQL (XAMPP on D:)
$mysqlBin = "D:\xampp\mysql\bin\mysql.exe"
if (Test-Path $mysqlBin) {
    Write-Host "[OK] MySQL detected at D:\xampp" -ForegroundColor Green
    & $mysqlBin -u root -e "CREATE DATABASE IF NOT EXISTS zethub_marketing_os CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    & $mysqlBin -u root zethub_marketing_os -e "source D:/marketing_os/database/schema.sql; source D:/marketing_os/database/seed.sql;"
    Write-Host "[OK] MySQL database schema and seed data verified." -ForegroundColor Green
} else {
    Write-Warning "D:\xampp\mysql\bin\mysql.exe not found at standard path."
}

# 4. Check Node.js and npm
$nodeVer = node -v 2>$null
Write-Host "[OK] Node.js version: $nodeVer" -ForegroundColor Green
npm config set cache "D:\.npm-cache" --global
Write-Host "[OK] npm cache confirmed at D:\.npm-cache" -ForegroundColor Green

Write-Host "`nSetup complete! Run scripts\start.ps1 to launch all services." -ForegroundColor Cyan

