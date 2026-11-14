# ZetHub Digital Marketing OS - Backup Script
$dateStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = "D:\marketing_os\database\backups"
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

$dumpFile = "$backupDir\zethub_marketing_os_$dateStamp.sql"
Write-Host "Creating MySQL database backup to $dumpFile..." -ForegroundColor Cyan

$mysqldump = "D:\xampp_new\mysql\bin\mysqldump.exe"
if (-not (Test-Path $mysqldump)) {
    $mysqldump = "D:\xampp\mysql\bin\mysqldump.exe"
}
if (Test-Path $mysqldump) {
    & $mysqldump -u root -h 127.0.0.1 -P 3306 --routines --triggers --databases zethub_marketing_os > $dumpFile
    Write-Host "[OK] Backup created successfully ($((Get-Item $dumpFile).Length) bytes)" -ForegroundColor Green
} else {
    Write-Warning "mysqldump.exe not found at $mysqldump"
}

