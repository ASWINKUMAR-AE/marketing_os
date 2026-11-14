# ZetHub Marketing OS - Database Schema & Entity Report

## 1. Database Overview

- **Database Name**: `zethub_marketing_os`
- **Host Engine**: MariaDB 10.4.32 (XAMPP in `D:\xampp_new\mysql\data`)
- **Default Charset**: `utf8mb4`
- **Default Collation**: `utf8mb4_unicode_ci`
- **Total Relational Tables**: 26

---

## 2. Table Catalog by Marketing Subsystem

### Subsystem A: Global Brand & Operating Configuration
1. **`settings`**: Key-value brand parameters, official URLs, typography, brand colors.
   - Verified records:
     - `COMPANY_NAME`: `ZETHUB TECHNOLOGIES PRIVATE LIMITED`
     - `COMPANY_TAGLINE`: `Where Innovations meets our Excellence`
     - `COMPANY_LOCATION`: `Madurai, Tamil Nadu, India`
     - `COMPANY_WEBSITE`: `https://zethub.in`
     - `LINKEDIN_URL`: `https://www.linkedin.com/company/zethub-technologies-private-limited`
     - `LINKEDIN_HANDLE`: `zethub-technologies-private-limited`
2. **`roles`**: Authorization tiers (`ADMIN`, `OPERATOR`, `REVIEWER`).
3. **`users`**: System user profiles and access roles.
4. **`platforms`**: Multi-channel distribution metadata (Instagram, LinkedIn, Website, Email, Telegram).
5. **`social_accounts`**: Platform credentials, organization handles, and authentication status.

### Subsystem B: Content Strategy, Creation & Validation
6. **`content_calendar`**: 7-day scheduled posts, topics, pillars, scheduled dates, and approval states (`DRAFTED`, `READY`, `APPROVED`, `PUBLISHED`).
7. **`generated_content`**: AI copy variants, hooks, body copy, hashtags, CTAs, and QA validation scores.
8. **`media_assets`**: Pillow-rendered graphic cards (1080x1350 vertical & 1080x1080 square) and public image URLs.
9. **`campaigns`**: Thematic marketing campaigns with date boundaries and conversion targets.
10. **`blog_posts`**: SEO-optimized technical blog drafts, case studies, and GitHub markdown files.

### Subsystem C: SEO Intelligence & Social Listening
11. **`seo_keywords`**: Target search terms, volume, difficulty, search intent, and ranking tracking.
12. **`seo_audits`**: Webpage crawl results, meta descriptions, headings, and IndexNow submission logs.
13. **`competitors`**: Competitor profiles and domain monitoring targets.
14. **`competitor_activity`**: Scanned competitor posts, hooks, estimated engagement, and strategic marketing gaps.

### Subsystem D: Inbound Lead CRM & Email Marketing
15. **`leads`**: Captured inbound prospects, company details, message transcripts, AI lead scores (0–100), and qualification badges (`HOT`, `WARM`, `COLD`).
16. **`lead_sources`**: Attribution tracking (Website, LinkedIn, Direct, Referral).
17. **`email_contacts`**: Opted-in newsletter subscribers and drip nurture campaign recipients.
18. **`email_suppressions`**: Hard bounce and unsubscribe lists for DPDP and CAN-SPAM compliance.

### Subsystem E: Publishing Engine & Execution Logs
19. **`publishing_queue`**: FIFO publication queue with scheduled publication timestamps.
20. **`publishing_logs`**: External platform response logs (Meta Graph API & LinkedIn UGC API post IDs).
21. **`automation_workflows`**: Registry of the 11 n8n automation pipelines and cron trigger definitions.
22. **`automation_executions`**: Execution history, duration, status (`SUCCESS`, `ERROR`), and affected row counts.

### Subsystem F: Analytics & Self-Healing Telemetry
23. **`analytics_daily`**: Post impressions, reach, CTR, likes, comments, and website visits.
24. **`marketing_reports`**: Weekly synthesized performance summaries and AI feedback recalibrations.
25. **`ai_requests`**: LLM token consumption logs, latency measurements, and prompt/response tracking.
26. **`system_logs`**: Event logs, error traces, backup completions, and watchdog alerts.

---

## 3. Relational Foreign Keys & Cascades

- `publishing_queue.calendar_id` ➔ `content_calendar.id` (`ON DELETE CASCADE`)
- `publishing_queue.platform_id` ➔ `platforms.id` (`ON DELETE CASCADE`)
- `generated_content.calendar_id` ➔ `content_calendar.id` (`ON DELETE CASCADE`)
- `media_assets.content_id` ➔ `generated_content.id` (`ON DELETE CASCADE`)
- `competitor_activity.competitor_id` ➔ `competitors.id` (`ON DELETE CASCADE`)
- `automation_executions.workflow_id` ➔ `automation_workflows.id` (`ON DELETE CASCADE`)
- `social_accounts.platform_id` ➔ `platforms.id` (`ON DELETE CASCADE`)

