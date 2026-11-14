# MySQL Connection & Architecture Report

## 1. Connection Architecture

The ZetHub Marketing OS communicates with XAMPP MySQL using a resilient connection architecture implemented in `backend/app/database/connection.py`:

```
┌─────────────────────────────────┐
│     ZetHub Backend Services     │
│   (FastAPI, CLI, n8n Engine)    │
└────────────────┬────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│  Connection Pool & Transaction  │
│      Manager (PyMySQL)          │
│   • Timeout: 5s / Read: 15s     │
│   • Autocommit / Rollback Guard │
│   • Ping Reconnection           │
└────────────────┬────────────────┘
                 │ (TCP: 127.0.0.1:3306)
                 ▼
┌─────────────────────────────────┐
│  XAMPP MariaDB 10.4.32 (AMD64)  │
│    Data: D:\xampp_new\mysql\    │
│    DB: zethub_marketing_os      │
└─────────────────────────────────┘
```

---

## 2. Technical Specifications

| Parameter | Specification |
|---|---|
| **Driver** | `pymysql` (Pure Python MySQL client) |
| **Cursor Class** | `pymysql.cursors.DictCursor` (Dictionary-based row access) |
| **Connect Timeout** | 5 seconds |
| **Read / Write Timeout** | 15 seconds |
| **Character Set** | `utf8mb4` |
| **Collation** | `utf8mb4_unicode_ci` |
| **Autocommit Mode** | Enabled by default; disabled during transactional blocks |
| **Reconnection Strategy** | Automatic connection health ping with reconnect support |

---

## 3. Real-Time Telemetry & Health Monitoring

The connection module continuously tracks health telemetry exposed via `GET /api/database/status`:

```json
{
  "status": "connected",
  "database": "zethub_marketing_os",
  "host": "127.0.0.1",
  "port": 3306,
  "server_version": "10.4.32-MariaDB",
  "data_directory": "D:\\xampp_new\\mysql\\data\\",
  "total_tables": 26,
  "last_successful_connection": "2026-11-14T11:40:37.811009",
  "latest_database_error": null,
  "engine": "XAMPP MySQL / MariaDB"
}
```

### Security Compliance
- **Credential Protection**: Passwords, authorization tokens, and internal keys are never exposed in JSON responses or log outputs.
- **Local Isolation**: The database listener binds strictly to `127.0.0.1` preventing remote external network exposure.
- **Parameterized SQL**: 100% of SQL queries utilize parameterized tuples (`%s`) preventing SQL injection.

---

## 4. Test Verification Summary

| Test ID | Description | Result | Details |
|---|---|---|---|
| **TEST-01** | MySQL Port 3306 Availability | **PASS** | Socket connected in < 2ms |
| **TEST-02** | Backend PyMySQL Handshake | **PASS** | MariaDB 10.4.32 verified |
| **TEST-03** | Database Existence Check | **PASS** | `zethub_marketing_os` verified |
| **TEST-04** | Table Schema Integrity | **PASS** | 26 tables verified |
| **TEST-05** | CRUD Operations | **PASS** | Clean Insert, Read, Update, Delete on test records |
| **TEST-06** | Transaction Rollback | **PASS** | Uncommitted/aborted writes cleanly reverted |
| **TEST-07** | Foreign Key Constraints | **PASS** | Orphan insertions rejected |
| **TEST-08** | n8n Registry Query | **PASS** | 11 production workflows active |
| **TEST-09** | Live Health Endpoint Telemetry | **PASS** | Valid payload returned |
| **TEST-10** | Reconnection & Ping | **PASS** | Handshake latency < 5ms |

