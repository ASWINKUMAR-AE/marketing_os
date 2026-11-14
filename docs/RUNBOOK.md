# ZetHub Marketing OS - Operational Runbook

## Daily Operations Workflow

### 07:00 IST — Industry Research & Trend Radar
- Automated n8n workflow `09-competitor-watch` fetches Google News RSS for Indian SME and AI automation trends.
- AI synthesizes content opportunities and market pulse.

### 08:00 IST — Content Creation & QA Verification
- Automated n8n workflow `02-content-generator` or manual dashboard trigger drafts platform-specific copy.
- Automatic QA Gate checks:
  - Instagram: character count <= 2,200, 8-15 hashtags.
  - LinkedIn: character count <= 3,000, 3-5 hashtags.
  - Banned word check: rejects get-rich-quick, crypto scams, or unverified claims.
  - Generates brand image on port 5001.
  - Content marked as `READY` if passed.

### 09:00 - 10:00 IST — Morning Approval Review
1. Administrator opens `http://localhost:5173`.
2. Inspects "Content Calendar" tab.
3. Reviews copy and rendered image preview.
4. Clicks "Approve" (status advances to `SCHEDULED`).

### 10:30 & 18:30 IST — Scheduled Social Publishing
- `04-publisher` workflow checks if current time >= scheduled time.
- Verifies `AUTO_PUBLISH=TRUE` and `EMERGENCY_KILL_SWITCH != TRUE`.
- In Dry-Run mode, dispatches full preview to Telegram bot.
- In Live mode, posts to Meta Graph API or LinkedIn API.

### 12:00 IST — Inbound Lead Triage
- Inbound inquiries from `https://zethub.in` arrive via `/api/leads/intake`.
- AI computes lead score (0-100) and intent category (`HOT`, `WARM`, `COLD`).
- Hot leads (score >= 75) trigger high-priority alerts for sales follow-up within 2 hours.

---

## Emergency Kill Switch & Pause

### Via Dashboard
- Click the red **Emergency Stop** button in the top-right header of `http://localhost:5173`.
- Immediately halts all publishing queues.

### Via Telegram Bot
- Send `/pause` to your configured Telegram alert bot.
- Workflow `10-watchdog` intercepts the command and sets `AUTO_PUBLISH=FALSE`.
- Send `/resume` to restore scheduled publishing.

---

## Routine Maintenance & Backups
1. **Weekly Database Backup**:
   ```powershell
   .\scripts\backup.ps1
   ```
2. **System Diagnostic**:
   ```powershell
   .\scripts\health-check.ps1
   ```
3. **Instagram Long-Lived Token Refresh**:
   Meta long-lived user tokens expire in 60 days. Run the refresh sub-workflow inside `10-watchdog` every 45 days.

