# ZetHub Digital Marketing OS - Setup & Installation Guide

## Architecture Overview
ZetHub Digital Marketing OS is a self-hosted, sovereign AI marketing automation platform deployed locally on Windows. It combines:
- **Vireonix AI**: Primary zero-cost intelligence engine (`POST https://vireonix.ai/v1/chat/completions`, model `auto`).
- **MySQL Database**: Running locally via XAMPP on port `3306`, managing the `zethub_marketing_os` database.
- **FastAPI Backend Server**: Running on port `8000`, providing unified REST endpoints for all 10 modules.
- **Brand Image Render Service**: Running on port `5001`, producing 1080x1350 and 1080x1080 brand graphics.
- **React Admin Dashboard**: Running on port `5173`, delivering dark navy/purple glassmorphism controls.
- **n8n Automation Engine**: Self-hosted on port `5678`, executing scheduled triggers and sub-workflows.
- **AI Terminal CLI**: Interactive CLI assistant via `python terminal/main.py`.

---

## Storage & Disk Protection (Drive D: Policy)
To prevent disk exhaustion on the primary `C:` drive, all assets, caches, databases, and dependencies are strictly anchored to the `D:` drive:
- Project Root: `D:\marketing_os`
- Virtual Environment: `D:\marketing_os\.venv`
- Database: `D:\xampp\mysql\data\zethub_marketing_os`
- npm Cache: `D:\.npm-cache`
- n8n User Data: `D:\marketing_os\n8n_data`
- Render Outputs: `D:\marketing_os\render_service\output`

---

## 1. Quick Start (1-Click Launch)
Open PowerShell in `D:\marketing_os` and run:
```powershell
.\scripts\start.ps1
```
This automatically verifies MySQL, launches the Image Render Service (:5001), launches the FastAPI Backend (:8000), and starts the React Dashboard (:5173).

To launch n8n:
```cmd
.\scripts\start-n8n.bat
```

To run the Terminal Assistant:
```powershell
.\.venv\Scripts\python.exe terminal\main.py
```

---

## 2. Platform Ports
| Service | URL / Port | Purpose |
|---|---|---|
| Admin Dashboard | `http://localhost:5173` | Visual control center, drafts, approvals, CRM |
| Backend API & Swagger Docs | `http://localhost:8000/docs` | REST microservices & documentation |
| Image Render Service | `http://localhost:5001/health` | High-res PNG brand template generator |
| n8n Workflow Engine | `http://localhost:5678` | Community Edition workflow scheduler |
| MySQL Database | `localhost:3306` | Central SQL relational data store |

---

## 3. Operating Modes
1. **APPROVAL (Default)**: AI creates content, runs QA validation, and schedules it as `READY`. Admin must click "Approve" before publication.
2. **MANUAL**: Publishing queue requires manual administrative dispatch.
3. **FULL_AUTOMATION**: Scheduled posts publish automatically when due. Activated only after tokens are verified.

**Emergency Stop**: Click "Emergency Stop" in the Dashboard header or set `EMERGENCY_KILL_SWITCH=TRUE` to halt all publishing immediately.

