# ZetHub Digital Marketing OS - XAMPP MySQL Configuration Guide

## 1. Selected XAMPP Environment & Specifications

Following the diagnostic audit of both XAMPP installations on drive `D:\`, the active 64-bit production XAMPP installation was selected:

| Parameter | Configuration Value |
|---|---|
| **Selected XAMPP Installation** | `D:\xampp_new\` (Active XAMPP Control Panel v3.3.0) |
| **MySQL / MariaDB Executable** | `D:\xampp_new\mysql\bin\mysqld.exe` |
| **Active Data Directory** | `D:\xampp_new\mysql\data\` |
| **Configuration File** | `D:\xampp_new\mysql\bin\my.ini` |
| **Server Engine & Version** | **10.4.32-MariaDB (AMD64)** |
| **Listen Host & Port** | `127.0.0.1:3306` (Local Loopback) |
| **Central Database Name** | `zethub_marketing_os` |
| **Character Set & Collation** | `utf8mb4` / `utf8mb4_unicode_ci` |
| **User & Authentication** | `root` / Empty Password (Standard XAMPP default) |

---

## 2. Port Conflict Investigation & Root Cause Resolution

### The Error
`Port 3306 in use by D:\xampp\mysql\bin\mysqld.exe`

### Forensic Investigation
1. **PID 17488 Ownership**: Port 3306 was occupied by an older 32-bit MariaDB 10.1 instance in `D:\xampp\mysql\bin\mysqld.exe` that had been started as a background daemon.
2. **User's Active Environment**: The user's active XAMPP Control Panel was running from `D:\xampp_new\`, where 64+ existing project databases reside (`zethub`, `zethub_crm`, `zethub_db`, `ai_crm`, etc.).
3. **Secondary Failure in `D:\xampp_new`**: When attempting to start MySQL from `D:\xampp_new`, MariaDB halted because an Aria system privilege index (`mysql/global_priv.MAI`) had been marked as crashed from a prior system shutdown.

### Execution of Safe Resolution (Zero Data Loss)
1. **Full Database Dump**: Backed up `zethub_marketing_os` from the old server to `D:\marketing_os\database\zethub_marketing_os_migration.sql` (all 26 tables verified).
2. **Graceful Shutdown**: Stopped the old `D:\xampp` instance cleanly via official `mysqladmin.exe shutdown` (never forceful `kill`), releasing port 3306 in 1 second.
3. **Aria Table Recovery**: Rebuilt `global_priv.MAI` in `D:\xampp_new\mysql\data\mysql` using XAMPP's official `aria_chk.exe -r -s` utility, restoring full privilege access without losing user accounts.
4. **Clean Launch**: Started `D:\xampp_new\mysql\bin\mysqld.exe` on port 3306.
5. **Database Import & Migration**: Imported `zethub_marketing_os` into MariaDB 10.4.32 and updated brand settings with ZetHub's exact company name and LinkedIn handle.
6. **Preservation**: All 65 existing databases in `D:\xampp_new\mysql\data` remain 100% intact and online.

---

## 3. How to Start & Stop XAMPP MySQL

### Method A: Via XAMPP Control Panel (GUI)
1. Open `D:\xampp_new\xampp-control.exe`.
2. Click the **Start** button next to **MySQL**.
3. Status will turn green indicating `Port: 3306`.

### Method B: Via Master Startup Script
```powershell
powershell -ExecutionPolicy Bypass -File D:\marketing_os\scripts\start.ps1
```
*(Automatically verifies if `mysqld` is running from `D:\xampp_new`, starts it if absent, and launches the Backend API and Render Service).*

### Method C: Graceful CLI Shutdown
```cmd
D:\xampp_new\mysql\bin\mysqladmin.exe -u root -h 127.0.0.1 -P 3306 shutdown
```

---

## 4. Configuration Synchronization

All components in `D:\marketing_os` are synchronized with `D:\xampp_new`:

- **`.env`**:
  ```ini
  MYSQL_HOST=127.0.0.1
  MYSQL_PORT=3306
  MYSQL_USER=root
  MYSQL_PASSWORD=
  MYSQL_DATABASE=zethub_marketing_os
  XAMPP_PATH=D:\xampp_new
  ```
- **Backend API**: `backend/app/database/connection.py` connects with 5s timeout and automatic reconnection.
- **Admin Dashboard**: Real-time status badge and MariaDB 10.4 telemetry displayed at [http://127.0.0.1:5173](http://127.0.0.1:5173).

