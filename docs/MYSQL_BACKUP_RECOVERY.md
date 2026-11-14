# ZetHub Marketing OS - MySQL Backup & Recovery Runbook

## 1. Overview

The ZetHub Marketing OS provides an automated, validated backup and disaster recovery subsystem powered by XAMPP's native `mysqldump.exe` and `mysql.exe` binaries located at `D:\xampp_new\mysql\bin\`.

---

## 2. Automated Daily Backup

### Script Location
`D:\marketing_os\scripts\backup_manager.py`

### How to Create an Immediate Backup
```powershell
D:\marketing_os\.venv\Scripts\python.exe D:\marketing_os\scripts\backup_manager.py --backup
```
Or via PowerShell wrapper:
```powershell
powershell -ExecutionPolicy Bypass -File D:\marketing_os\scripts\backup.ps1
```

### What Happens During Backup
1. **Timestamped Export**: Exports `zethub_marketing_os` to `D:\marketing_os\database\backups\zethub_marketing_os_YYYYMMDD_HHMMSS.sql`.
2. **Complete Scope**: Includes routines, triggers, relational constraints, and seed data.
3. **Automated Validation**:
   - Verifies the file size is non-empty (> 10 KB).
   - Validates that at least 20 `CREATE TABLE` definitions exist in the dump.
4. **Retention Pruning**: Automatically retains the latest 30 backups and safely prunes older files to prevent disk exhaustion.
5. **Event Logging**: Logs backup completion to the `system_logs` table in MySQL.

---

## 3. Disaster Recovery (Restore Procedure)

### Step 1: Identify the Desired Backup File
Check the backups folder:
```powershell
Get-ChildItem -Path D:\marketing_os\database\backups\ -Filter "*.sql" | Sort-Object LastWriteTime -Descending
```

### Step 2: Execute Restore
Run the restore command specifying the target SQL file:
```powershell
D:\marketing_os\.venv\Scripts\python.exe D:\marketing_os\scripts\backup_manager.py --restore D:\marketing_os\database\backups\zethub_marketing_os_20261114_114228.sql
```

### Step 3: Verify Database Post-Restore
Run the diagnostic test suite to ensure table integrity:
```powershell
D:\marketing_os\.venv\Scripts\python.exe -m pytest tests/test_xampp_mysql.py -v
```

---

## 4. Scheduled Daily Backup Automation

To automate daily backups at 02:00 AM on Windows without third-party tools, configure a Windows Task Scheduler job:

```powershell
$action = New-ScheduledTaskAction -Execute "D:\marketing_os\.venv\Scripts\python.exe" -Argument "D:\marketing_os\scripts\backup_manager.py --backup" -WorkingDirectory "D:\marketing_os"
$trigger = New-ScheduledTaskTrigger -Daily -At 2:00AM
Register-ScheduledTask -TaskName "ZetHub_Marketing_OS_Daily_Backup" -Action $action -Trigger $trigger -Description "Nightly verified backup of ZetHub Marketing OS database"
```

