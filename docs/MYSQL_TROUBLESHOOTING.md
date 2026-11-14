# ZetHub Marketing OS - XAMPP MySQL Troubleshooting Guide

This guide addresses common errors and operational procedures for MySQL/MariaDB in the ZetHub Marketing OS.

---

## 1. Port 3306 Conflict

### Symptom
XAMPP Control Panel displays:
`Port 3306 in use by D:\xampp\mysql\bin\mysqld.exe` or `Port 3306 in use by mysqld.exe`

### Root Cause
An older or orphaned `mysqld.exe` process is already listening on port 3306.

### Resolution (Never use forceful kill)
1. Run graceful shutdown via mysqladmin:
   ```cmd
   D:\xampp_new\mysql\bin\mysqladmin.exe -u root -h 127.0.0.1 -P 3306 shutdown
   ```
   *(If port was held by old D:\xampp: `D:\xampp\mysql\bin\mysqladmin.exe -u root -h 127.0.0.1 -P 3306 shutdown`)*
2. Verify port 3306 is free:
   ```powershell
   netstat -ano | findstr 3306
   ```
3. Start the correct XAMPP instance from `D:\xampp_new\xampp-control.exe` or `scripts\start.ps1`.

---

## 2. Table `global_priv` Corrupted on Startup

### Symptom
MySQL fails to start and `mysql_error.log` reports:
`[ERROR] mysqld.exe: Table '.\mysql\global_priv' is marked as crashed and should be repaired`
`[ERROR] Fatal error: Can't open and lock privilege tables: Index for table 'global_priv' is corrupt`

### Root Cause
An unclean reboot or sudden laptop shutdown damaged the Aria storage engine index (`global_priv.MAI`).

### Resolution (Zero Data Loss)
1. Navigate to data directory:
   ```cmd
   cd /d D:\xampp_new\mysql\data
   ```
2. Reconstruct the index definition using the template from backup:
   ```cmd
   copy /y D:\xampp_new\mysql\backup\mysql\global_priv.MAI D:\xampp_new\mysql\data\mysql\global_priv.MAI
   ```
3. Run official Aria table check and repair:
   ```cmd
   D:\xampp_new\mysql\bin\aria_chk.exe -r -s mysql/global_priv.MAI
   ```
4. Start MySQL normally. All user privileges and records in `global_priv.MAD` are fully restored.

---

## 3. Connection Refused: `[WinError 10061]`

### Symptom
Backend API reports:
`Can't connect to MySQL server on '127.0.0.1' ([WinError 10061] No connection could be made because the target machine actively refused it)`

### Root Cause
MySQL service is not currently running.

### Resolution
Start the service via:
```powershell
powershell -ExecutionPolicy Bypass -File D:\marketing_os\scripts\start.ps1
```
Or click **Start** next to MySQL in `D:\xampp_new\xampp-control.exe`.

---

## 4. Key Too Long Error (MariaDB 10.1 Antelope Limit)

### Symptom
`Specified key was too long; max key length is 767 bytes`

### Root Cause
Old MariaDB 10.1 (in `D:\xampp`) defaults to Antelope format (767-byte limit on utf8mb4 keys).

### Resolution
The active server was upgraded to **MariaDB 10.4.32 (AMD64 in `D:\xampp_new`)**, which defaults to InnoDB Barracuda format with dynamic row format (supporting up to 3072 bytes per index). All unique keys in `schema.sql` are also constrained to `VARCHAR(190)` for universal backwards compatibility.

---

## 5. Safety Protocols & Best Practices

1. **Never kill `mysqld.exe` via Task Manager**: Force-killing `mysqld.exe` interrupts InnoDB log writes and risks corruption of `ibdata1` or `global_priv`. Always use `mysqladmin shutdown` or the XAMPP Control Panel Stop button.
2. **Never overwrite or delete `ibdata1`**: The shared tablespace file stores dictionary metadata for all 65 user databases.
3. **Daily Automated Backups**: Verify that `D:\marketing_os\database\backups\` contains recent timestamped `.sql` dumps.

