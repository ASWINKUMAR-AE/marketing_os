# ZetHub Marketing OS - Data Schema Reference

## Relational MySQL Tables & Google Sheets Mirror

### 1. `Config` Tab (Settings Table)
| Field | Type | Description | Example |
|---|---|---|---|
| `setting_key` | VARCHAR(100) | Unique configuration identifier | `AUTO_PUBLISH` |
| `setting_value` | TEXT | Setting value string | `TRUE` or `FALSE` |
| `description` | VARCHAR(255) | Setting purpose | `Global publishing gate` |

### 2. `Calendar` Tab (content_calendar Table)
| Field | Type | Description | Example |
|---|---|---|---|
| `content_id` | VARCHAR(64) | Unique post tracking ID | `ZH-D9B4A102` |
| `topic` | VARCHAR(255) | Content title or concept | `Cut 15 Hours Weekly on Textile Inventory` |
| `platform` | VARCHAR(50) | Target platform | `Instagram` or `LinkedIn` |
| `content_category` | VARCHAR(100) | Content pillar | `Educational`, `Technical`, `Product` |
| `caption` | TEXT | Platform-formatted copy | Full text with linebreaks & emojis |
| `hashtags` | VARCHAR(500) | Hashtags | `#ZetHub #AIautomation #IndianSMEs` |
| `image_url` | VARCHAR(1000) | Public/local rendered image URL | `http://localhost:5001/images/tip_xyz.png` |
| `cta` | VARCHAR(255) | Call to action string | `Visit zethub.in to learn more` |
| `scheduled_at` | DATETIME | Planned publishing timestamp | `2026-11-15 10:30:00` |
| `approval_status` | ENUM | Review state | `DRAFT`, `APPROVED`, `REJECTED` |
| `publishing_status` | ENUM | Execution pipeline status | `IDEA`, `DRAFTED`, `RENDERED`, `READY`, `SCHEDULED`, `PUBLISHED`, `FAILED` |

### 3. `Leads` Tab (leads Table)
| Field | Type | Description | Example |
|---|---|---|---|
| `full_name` | VARCHAR(150) | Inquirer contact name | `Rajesh Kumar` |
| `email` | VARCHAR(190) | Business email address | `rajesh@spinners.in` |
| `company` | VARCHAR(150) | Organization name | `Madurai Spinners Ltd` |
| `lead_score` | INT | Objective AI score (0-100) | `88` |
| `category` | ENUM | Intent segment | `HOT`, `WARM`, `COLD` |
| `status` | ENUM | CRM sales pipeline status | `NEW`, `QUALIFIED`, `CONTACTED`, `CONVERTED` |
| `consent` | BOOLEAN | DPDP opt-in flag | `TRUE` |

### 4. `Keywords` Tab (seo_keywords Table)
| Field | Type | Description | Example |
|---|---|---|---|
| `keyword` | VARCHAR(190) | Target search term | `AI automation for Indian SMEs` |
| `search_intent` | VARCHAR(100) | Buyer search intent | `Commercial` |
| `monthly_volume` | INT | Approximate volume | `1200` |
| `priority` | ENUM | Strategic importance | `HIGH`, `MEDIUM`, `LOW` |
| `status` | ENUM | Content progress | `DISCOVERED`, `PLANNED`, `PUBLISHED` |

