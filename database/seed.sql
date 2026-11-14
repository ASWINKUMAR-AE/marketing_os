-- ZetHub Digital Marketing Automation OS
-- Seed Data
USE zethub_marketing_os;

-- Settings
INSERT INTO settings (setting_key, setting_value, description) VALUES
('COMPANY_NAME', 'ZetHub', 'Brand company name'),
('COMPANY_TAGLINE', 'AI SaaS & IT Solutions for Modern Enterprises', 'Company tagline'),
('COMPANY_LOCATION', 'Madurai, Tamil Nadu, India', 'Headquarters location'),
('COMPANY_WEBSITE', 'https://zethub.in', 'Official website URL'),
('TARGET_AUDIENCE', 'Indian SMEs, Startups, Founders, Textile & Manufacturing businesses seeking AI automation and software solutions', 'Target buyer personas'),
('BRAND_VOICE', 'Authoritative, innovative, practical, value-driven, professional, accessible', 'Brand tone of voice'),
('AUTO_PUBLISH', 'FALSE', 'Global auto-publish toggle (TRUE=publish, FALSE=draft/pause)'),
('OPERATING_MODE', 'APPROVAL', 'Current operating mode: MANUAL, APPROVAL, FULL_AUTOMATION'),
('INSTAGRAM_POSTING_TIMES', '10:30,18:30', 'Configured daily posting times in IST'),
('LINKEDIN_POSTING_TIMES', '09:00,16:30', 'Configured daily posting times in IST'),
('EMERGENCY_KILL_SWITCH', 'FALSE', 'Global emergency stop (TRUE halts all publishing immediately)'),
('DAILY_POST_LIMIT', '2', 'Max social posts per platform per day'),
('QA_BANNED_WORDS', 'guaranteed profits,crypto scam,get rich quick,100% free money,miracle solution', 'Comma-separated banned words')
ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value);

-- Platforms
INSERT INTO platforms (id, name, is_active, api_status, config_json) VALUES
(1, 'Instagram', TRUE, 'READY_FOR_AUTH', '{"api_version": "v21.0", "rate_limit_per_day": 25}'),
(2, 'LinkedIn', TRUE, 'READY_FOR_AUTH', '{"api_version": "202401", "rate_limit_per_day": 50}'),
(3, 'Website CMS / GitHub', TRUE, 'CONNECTED', '{"repo": "zethub/website", "branch": "main", "blog_dir": "content/blog"}'),
(4, 'Email / Brevo', TRUE, 'CONFIGURED', '{"provider": "brevo", "daily_free_limit": 300}'),
(5, 'Telegram Alerts', TRUE, 'CONNECTED', '{"bot_name": "ZetHubMarketingBot"}')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Lead Sources
INSERT INTO lead_sources (source_name, source_type) VALUES
('Website Inquiry Form', 'WEB_FORM'),
('LinkedIn Inbound', 'SOCIAL'),
('Newsletter Signup', 'EMAIL_OPTIN'),
('Direct Referral', 'REFERRAL')
ON DUPLICATE KEY UPDATE source_type=VALUES(source_type);

-- Workflows
INSERT INTO automation_workflows (workflow_code, name, is_active, trigger_schedule, status) VALUES
('WF00_AI_GATEWAY', 'AI Gateway & Fallback Router', TRUE, 'Sub-workflow', 'ACTIVE'),
('WF01_AI_MARKETING_MANAGER', 'AI Marketing Manager & Strategy Planner', TRUE, 'Daily 07:00 IST', 'ACTIVE'),
('WF02_CONTENT_FACTORY', 'AI Social & Educational Content Factory', TRUE, 'Daily 08:00 IST', 'ACTIVE'),
('WF03_MEDIA_FACTORY', 'Creative Media & Image Renderer Service', TRUE, 'On Content Ready', 'ACTIVE'),
('WF04_SOCIAL_PUBLISHER', 'Social Media Publishing & Queue Engine', TRUE, 'Every 30 Mins', 'APPROVAL_MODE'),
('WF05_SEO_AUTOMATION', 'SEO Crawler, Audit & Keyword Intelligence', TRUE, 'Daily 14:00 IST', 'ACTIVE'),
('WF06_BLOG_AUTOMATION', 'AI Technical Blog & Article Engine', TRUE, 'Tue, Thu 16:00 IST', 'ACTIVE'),
('WF07_LEAD_GENERATION_CRM', 'AI Inbound Lead Intake & CRM Scoring', TRUE, 'On Inbound Lead / 5m Poll', 'ACTIVE'),
('WF08_EMAIL_MARKETING', 'AI Newsletter & Nurture Campaign Engine', TRUE, 'Weekly Fri 10:00 IST', 'ACTIVE'),
('WF09_ANALYTICS_REPORTS', 'Multi-Platform Analytics & Report Generator', TRUE, 'Daily 20:00 IST', 'ACTIVE'),
('WF10_ERROR_MONITOR', 'System Watchdog & Telegram Alert Monitor', TRUE, 'Every 15 Mins', 'ACTIVE')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Initial SEO Keywords
INSERT INTO seo_keywords (keyword, search_intent, monthly_volume, difficulty, priority, status) VALUES
('AI automation for Indian SMEs', 'Commercial', 1200, 'Low', 'HIGH', 'PLANNED'),
('SaaS development company Madurai', 'Commercial', 800, 'Low', 'HIGH', 'DISCOVERED'),
('Custom ERP software for textile industry', 'Commercial', 1500, 'Medium', 'HIGH', 'PLANNED'),
('How to automate business workflows using AI', 'Informational', 4500, 'Medium', 'HIGH', 'DISCOVERED'),
('Cost of custom software development in India', 'Commercial', 3200, 'Medium', 'MEDIUM', 'DISCOVERED'),
('n8n enterprise automation consulting', 'Commercial', 950, 'Low', 'MEDIUM', 'DISCOVERED')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword);

-- Sample Competitors for tracking
INSERT INTO competitors (name, website, notes) VALUES
('Freshworks', 'https://www.freshworks.com', 'Major Indian SaaS leader in CRM and IT services'),
('Zoho', 'https://www.zoho.com', 'Dominant SaaS and business operating system suite from Tamil Nadu')
ON DUPLICATE KEY UPDATE website=VALUES(website);

