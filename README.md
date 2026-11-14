# ZetHub Digital Marketing Automation OS

[![Python](https://img.shields.io/badge/Python-3.12-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110+-green.svg)](https://fastapi.tiangolo.com/)
[![React](https://img.shields.io/badge/React-18.0-61dafb.svg)](https://react.dev/)
[![Vite](https://img.shields.io/badge/Vite-6.0-646cff.svg)](https://vitejs.dev/)
[![Database](https://img.shields.io/badge/Database-MariaDB%2010.4-orange.svg)](https://mariadb.org/)
[![Orchestration](https://img.shields.io/badge/Orchestrator-n8n%20Community-ff6d5a.svg)](https://n8n.io/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)]()

> **Sovereign, 100% Free, Self-Hosted Digital Marketing Automation OS**  
> Engineered for **ZETHUB TECHNOLOGIES PRIVATE LIMITED**  
> *“Where Innovations meets our Excellence”*  
> **Headquarters:** Madurai, Tamil Nadu, India | **Website:** [https://zethub.in](https://zethub.in) | **LinkedIn:** [linkedin.com/company/zethub-technologies-private-limited](https://www.linkedin.com/company/zethub-technologies-private-limited)

---

## 1. Executive Overview

**ZetHub Digital Marketing OS** is a self-hosted, enterprise-grade autonomous marketing platform designed to run locally on Windows (Drive `D:\`) using a 100% free software stack.

It autonomously manages the end-to-end marketing lifecycle:
1. **Intelligence & Research**: Competitor intelligence, market gap scanning, and keyword tracking.
2. **Strategy & Planning**: 7-day multi-channel editorial calendars aligned with brand pillars.
3. **Content Creation**: AI copy generation (hooks, body, hashtags, CTAs) via Vireonix AI with Groq/heuristic fallbacks.
4. **Visual Asset Generation**: Automated high-resolution social graphic rendering (1080x1350 vertical & 1080x1080 square) using Python Pillow.
5. **Quality & Compliance Gate**: Automated brand voice validation, spam detection, and hallucination guardrails.
6. **Multi-Channel Distribution**: Automated publishing to LinkedIn, Instagram (Meta Graph API), Website CMS, and Telegram alerts.
7. **Lead CRM & Attribution**: Inbound lead capture with AI qualification scoring (0–100, `HOT`/`WARM`/`COLD`) and Brevo email marketing.
8. **Feedback Loop**: Weekly analytics aggregation and closed-loop strategy recalibration.

---

## 2. Overall System Architecture

```
                       ┌────────────────────────────────────────────────────────┐
                       │              ZetHub Business Information               │
                       │    Products · Services · Audience · Brand · Website    │
                       └───────────────────────────┬────────────────────────────┘
                                                   │
                                                   ▼
                       ┌────────────────────────────────────────────────────────┐
                       │          Vireonix AI Marketing Manager                 │
                       │   Research · Planning · Decision-making · Generation   │
                       └───────────────────────────┬────────────────────────────┘
                                                   │
         ┌───────────────────┬─────────────────────┴───────────────────┬───────────────────┐
         ▼                   ▼                                         ▼                   ▼
┌─────────────────┐ ┌─────────────────┐                       ┌─────────────────┐ ┌─────────────────┐
│   01 Research   │ │   02 Strategy   │                       │   03 Content    │ │  04 Validation  │
│ Industry & comp │ │ Topics & camp.  │                       │  Text & Media   │ │ Quality & brand │
└────────┬────────┘ └────────┬────────┘                       └────────┬────────┘ └────────┬────────┘
         │                   │                                         │                   │
         └───────────────────┼─────────────────────────────────────────┴───────────────────┘
                             │
                             ▼
     ┌─────────────────────────────────────────────────────────────────────────────────┐
     │                             n8n Automation Engine                               │
     │               Schedule · Database · APIs · Publishing · Notifications           │
     └───────────────────────────────────────┬─────────────────────────────────────────┘
                                             │
      ┌─────────────┬─────────────┬──────────┴──────────┬─────────────┬─────────────┐
      ▼             ▼             ▼                     ▼             ▼             ▼
┌───────────┐ ┌───────────┐ ┌───────────┐         ┌───────────┐ ┌───────────┐ ┌───────────┐
│ Instagram │ │ LinkedIn  │ │  Website  │         │    SEO    │ │   Email   │ │   Leads   │
│Graph & CDN│ │ v2 UGC API│ │ Webhooks  │         │ IndexNow  │ │   Brevo   │ │ Qual. CRM │
└─────┬─────┘ └─────┬─────┘ └─────┬─────┘         └─────┬─────┘ └─────┬─────┘ └─────┬─────┘
      │             │             │                     │             │             │
      └─────────────┴─────────────┴──────────┬──────────┴─────────────┴─────────────┘
                                             │
                                             ▼
                       ┌────────────────────────────────────────────────────────┐
                       │             Analytics and AI Feedback Loop             │
                       │     Performance  ──▶  Insights  ──▶  New Strategy      │
                       └────────────────────────────────────────────────────────┘
```

---

## 3. Tech Stack & Ports

| Component | Technology | Default Port / Location | Purpose |
|---|---|---|---|
| **Admin Dashboard** | React 18, TypeScript, Vite, Glassmorphism | `http://127.0.0.1:5173` | Visual control center with 15 modules |
| **Backend API** | FastAPI, Uvicorn, PyMySQL | `http://127.0.0.1:8000` | REST API with Swagger docs (`/docs`) |
| **Render Microservice** | Python Pillow, Jinja2, Uvicorn | `http://127.0.0.1:5001` | Automated 1080x1350 social poster generator |
| **Central Database** | XAMPP MariaDB 10.4.32 (AMD64) | `localhost:3306` | 26 relational tables (`zethub_marketing_os`) |
| **Workflow Engine** | n8n Community Edition | `http://127.0.0.1:5678` | 11 production automation workflows |
| **Terminal Assistant** | Python Prompt-Toolkit | Local CLI | Interactive assistant (`python terminal/main.py`) |
| **Primary AI Engine** | Vireonix AI (`auto` model) | HTTPS API | Free LLM content generation & strategy |
| **Fallback AI Engine** | Groq / Llama-3.3-70b / Rules | HTTPS API | Resilient failover with backoff retry |

---

## 4. Directory Structure

```
D:\marketing_os
├── backend/
│   ├── app/
│   │   ├── api/endpoints.py          # 17 Module REST endpoints & DB health telemetry
│   │   ├── database/connection.py    # PyMySQL connection pool, transactions & ping
│   │   ├── services/ai_service.py    # Vireonix AI + 3-stage backoff & heuristic fallback
│   │   └── main.py                   # FastAPI server entry point (:8000)
│   └── requirements.txt
├── render_service/
│   ├── app.py                        # Brand graphic microservice (:5001)
│   ├── templates.py                  # 4 Pillow layouts (Quote, Tip, Feature, Announcement)
│   └── output/                       # High-res rendered PNG outputs (1080x1350 & 1080x1080)
├── frontend/
│   ├── src/                          # React + TypeScript source
│   │   ├── App.tsx                   # 15 Module Views + Live XAMPP DB Status Card
│   │   ├── index.css                 # Dark Navy/Purple Glassmorphic theme
│   │   └── main.tsx
│   ├── dist/                         # Compiled production bundle
│   └── package.json
├── terminal/
│   ├── main.py                       # Windows AI Terminal Assistant CLI
│   ├── commands.py                   # /status, /generate, /content, /leads, /validate
│   └── ai_client.py                  # Direct terminal AI client
├── workflows/                        # 11 Production n8n Workflow JSONs
│   ├── 00-ai-gateway.json            # Central AI dispatcher with retry logic
│   ├── 01-research-competitor.json   # Competitor scraper & industry gap analyzer
│   ├── 02-strategy-planner.json      # 7-day content calendar generator
│   ├── 03-content-creator.json       # Copywriting & render trigger pipeline
│   ├── 04-quality-gate.json          # AI brand voice validator & spam guardrail
│   ├── 05-publisher.json             # Instagram Graph API & LinkedIn UGC publisher
│   ├── 06-social-listening.json      # Brand mentions & engagement scanner
│   ├── 07-seo-pipeline.json          # Google autocomplete scraper & IndexNow submitter
│   ├── 08-lead-qualification.json   # Inbound CRM scoring (0-100) & Brevo nurture
│   ├── 09-weekly-analytics.json      # Closed-loop weekly KPI aggregator
│   └── 10-watchdog.json              # Self-healing process & database watchdog
├── database/
│   ├── schema.sql                    # 26 relational MySQL tables (MariaDB 10.4)
│   ├── seed.sql                      # Pre-populated brand settings, pillars & keywords
│   └── backups/                      # Validated timestamped SQL dumps
├── docs/                             # Comprehensive Technical Documentation
│   ├── XAMPP_MYSQL_SETUP.md          # Database setup, paths, and conflict resolution
│   ├── MYSQL_CONNECTION_REPORT.md    # PyMySQL pooling, security & test matrix
│   ├── DATABASE_SCHEMA_REPORT.md     # 26-table entity relational catalog
│   ├── MYSQL_BACKUP_RECOVERY.md      # Automated backup, retention & restore runbook
│   └── MYSQL_TROUBLESHOOTING.md      # Common errors (3306, global_priv, aria_chk)
├── prompts/                          # 11 System Prompts with strict JSON specifications
├── scripts/
│   ├── start.ps1                     # 1-Click Master startup (MySQL, API, Render, UI)
│   ├── stop.ps1                      # Graceful shutdown script
│   ├── health-check.ps1              # System diagnostic health check
│   ├── backup_manager.py             # Validated automated backup & restore manager
│   ├── backup.ps1                    # PowerShell backup wrapper
│   └── start-n8n.bat                 # n8n Automation Engine launcher
├── tests/                            # Automated Pytest Suite (45 Tests)
│   ├── test_xampp_mysql.py           # 10 Mandated XAMPP MySQL integration tests
│   ├── test_ai_gateway.py            # AI Gateway connectivity, parsing & retry tests
│   ├── test_backend_api.py           # REST endpoints test suite
│   ├── test_database.py              # Schema, constraints, rollback tests
│   ├── test_render_service.py        # Pillow image generation tests
│   └── test_security.py              # Anti-SQL injection & XSS tests
├── .env.example                      # Environment variables template
└── .gitignore                        # Strict ignore for secrets, caches, and backups
```

---

## 5. Prerequisites & Installation

### Prerequisites
- **Operating System**: Windows 10 / 11 (64-bit)
- **Python**: 3.12+ (64-bit)
- **Node.js**: v20+ or v24+
- **XAMPP**: Running from `D:\xampp_new\` or `D:\xampp\` with MariaDB on port 3306
- **Storage Policy**: Isolated to Drive `D:\` (zero C: drive bloat)

### Step 1: Clone Repository
```powershell
Set-Location D:\
git clone https://github.com/ASWINKUMAR-AE/marketing_os.git
Set-Location D:\marketing_os
```

### Step 2: Set Up Python Virtual Environment
```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r backend/requirements.txt
```

### Step 3: Set Up Frontend Dependencies
```powershell
Set-Location D:\marketing_os\frontend
npm install
npm run build
Set-Location D:\marketing_os
```

### Step 4: Configure Environment Variables
Copy `.env.example` to `.env`:
```powershell
Copy-Item .env.example .env
```
Ensure your database parameters in `.env`:
```ini
MYSQL_HOST=127.0.0.1
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=
MYSQL_DATABASE=zethub_marketing_os
```

### Step 5: Initialize XAMPP Database
1. Start MySQL in your XAMPP Control Panel (`D:\xampp_new\xampp-control.exe`).
2. Import the schema and seed data:
```powershell
D:\xampp_new\mysql\bin\mysql.exe -u root -h 127.0.0.1 -P 3306 < database\schema.sql
D:\xampp_new\mysql\bin\mysql.exe -u root -h 127.0.0.1 -P 3306 zethub_marketing_os < database\seed.sql
```

---

## 6. How to Run the System

### Method 1: 1-Click Master Startup (Recommended)
Run the master PowerShell startup script:
```powershell
powershell -ExecutionPolicy Bypass -File D:\marketing_os\scripts\start.ps1
```
This automatically:
1. Verifies that XAMPP MySQL is active on port 3306 (starts it if needed).
2. Launches the **Brand Render Service** on `http://127.0.0.1:5001`.
3. Launches the **FastAPI Backend Server** on `http://127.0.0.1:8000`.
4. Launches the **React Admin Dashboard** on `http://127.0.0.1:5173`.

### Method 2: Launch n8n Automation Engine
```cmd
D:\marketing_os\scripts\start-n8n.bat
```
- Open `http://localhost:5678` in your browser.
- Import the 11 workflows from `D:\marketing_os\workflows\`.

### Method 3: Launch AI Terminal CLI Assistant
```powershell
.\.venv\Scripts\python.exe terminal\main.py
```
Available CLI commands:
- `/status` — System health, database connection, and pipeline counts.
- `/generate` — Interactively draft copy and trigger Pillow rendering.
- `/content` — View pending drafts and approval status.
- `/leads` — Inspect inbound leads and AI qualification scores.
- `/validate "Your text"` — Run QA brand voice check on draft copy.
- `/help` — List all CLI options.

---

## 7. Testing & Quality Verification

Run the comprehensive 45-test automated test suite:
```powershell
.\.venv\Scripts\python.exe -m pytest tests/ -v
```

### Test Suite Coverage:
- **`test_xampp_mysql.py` (10/10 PASS)**: Port availability, PyMySQL connection, 26-table schema integrity, CRUD operations, transaction rollback, foreign key constraints, n8n connectivity, live health endpoint telemetry, and reconnection handling.
- **`test_ai_gateway.py` (14/14 PASS)**: Vireonix AI API connectivity, clean JSON parsing, 429/502 handling, 3-stage exponential backoff, code fence stripping, and rule-based heuristic fallbacks.
- **`test_backend_api.py` (7/7 PASS)**: Health check, Settings API, Content CRUD, Lead intake, SEO & Blogs, Competitor monitoring, Analytics overview.
- **`test_database.py` (5/5 PASS)**: Relational tables, unique constraints, rollback protection, cascade deletions.
- **`test_render_service.py` (4/4 PASS)**: Quote (1080x1350), Product Feature (1080x1080), Technical Tip, and Announcement card generation.
- **`test_security.py` (3/3 PASS)**: Parameterized anti-SQL injection defense, XSS payload neutralization, and credential exposure prevention.

---

## 8. Database Backup & Disaster Recovery

The system includes an automated backup manager located at `scripts/backup_manager.py`:

### Create Immediate Validated Backup:
```powershell
.\.venv\Scripts\python.exe scripts\backup_manager.py --backup
```
- Creates timestamped SQL dump: `database/backups/zethub_marketing_os_YYYYMMDD_HHMMSS.sql`.
- Validates file size (>10KB) and checks that all tables are present.
- Retains latest 30 backups automatically and prunes older ones.
- Logs backup events to `system_logs` table.

### Restore Database from Backup:
```powershell
.\.venv\Scripts\python.exe scripts\backup_manager.py --restore database\backups\zethub_marketing_os_20261114_114228.sql
```

---

## 9. Going Live (Social Media & Email Integration)

The system runs safely in **`APPROVAL` mode** (`AUTO_PUBLISH=FALSE`) by default. When you are ready to publish live, configure your free API keys in `.env`:

- **LinkedIn**: Add `LINKEDIN_CLIENT_ID`, `LINKEDIN_CLIENT_SECRET`, and `LINKEDIN_ACCESS_TOKEN`.
- **Instagram**: Add `INSTAGRAM_ACCOUNT_ID` and `INSTAGRAM_ACCESS_TOKEN` (Meta Graph API).
- **Cloudinary**: Add `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET` (for public image URLs required by Instagram).
- **Telegram Bot**: Add `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` (for instant approval buttons and kill switch alerts).
- **Brevo**: Add `BREVO_API_KEY` (for automated lead nurture emails, free 300/day).

---

## 10. License & Intellectual Property

Proprietary Software — Developed specifically for **ZETHUB TECHNOLOGIES PRIVATE LIMITED** (Madurai, Tamil Nadu, India). All rights reserved.
