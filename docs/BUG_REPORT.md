# ZetHub Digital Marketing OS - Bug Report & Audit Log

## Discovered Issues & Severity

| Bug ID | Component | Severity | Description | Status |
|---|---|---|---|---|
| **BUG-001** | Drive C: Storage | Critical | Default global npm cache targeted `C:\Users\Aswin\AppData\Local\npm-cache`, exhausting C: drive down to 0.02 GB. | **RESOLVED** |
| **BUG-002** | MySQL MariaDB 10.1 | High | `VARCHAR(255) UNIQUE` exceeded MariaDB's 767-byte index limit in utf8mb4 collation. | **RESOLVED** |
| **BUG-003** | AI Gateway | Medium | Vireonix AI API occasionally throws HTTP 502 Bad Gateway during heavy usage periods. | **RESOLVED** |
| **BUG-004** | TypeScript Frontend | Medium | `Property 'phone' does not exist on type 'LeadItem'` caused Vite production build failure. | **RESOLVED** |
| **BUG-005** | Backend Endpoints | Medium | Missing REST endpoints for competitor tracking, blog viewing, publishing logs, and manual publish triggers. | **RESOLVED** |
| **BUG-006** | Dashboard Navigation | Low | Frontend was missing dedicated views for Instagram Studio, LinkedIn Studio, Competitor Radar, and Diagnostics. | **RESOLVED** |

---

## Detailed Root Cause Analysis

### BUG-001: C: Drive npm Cache Exhaustion
- **Root Cause**: Node.js and npm defaulted to `C:\Users\Aswin\AppData\Local\npm-cache` for global caching and npx execution.
- **Impact**: Disk space on `C:` dropped below 25MB, halting subsequent installs.
- **Resolution**:
  1. Purged temporary cache files on `C:`.
  2. Permanently reconfigured npm cache to `D:\.npm-cache` via `npm config set cache D:\.npm-cache --global`.
  3. Re-routed n8n data directory to `D:\marketing_os\n8n_data`.
  4. C: drive restored to **3.71 GB** free space.

### BUG-002: MariaDB 767-byte Index Limit
- **Root Cause**: MariaDB 10.1 in XAMPP defaults to Antelope file format where utf8mb4 indexes cannot exceed 767 bytes (191 characters * 4 bytes = 764 bytes <= 767 bytes). Defining `VARCHAR(255) UNIQUE` required 1020 bytes.
- **Resolution**: Updated `schema.sql` so all unique and indexed strings are `VARCHAR(190)` or `VARCHAR(100)`.

### BUG-003: Vireonix AI 502 / Read Timeout Resilience
- **Root Cause**: Free third-party AI endpoints may drop connections or time out under high load.
- **Resolution**: Implemented exponential backoff retry in `ai_service.py` (attempts 1, 2, 3), and introduced deterministic rule-based heuristic fallbacks for QA validation and lead qualification if the upstream API is unavailable.

### BUG-004: Frontend TypeScript Interface Mismatch
- **Root Cause**: `LeadItem` interface in `App.tsx` omitted the optional `phone?: string` field while rendering the table cell.
- **Resolution**: Added `phone?: string` to `LeadItem` in `frontend/src/App.tsx`. Vite compilation succeeded in 5.15s.

