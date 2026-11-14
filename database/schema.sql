-- ZetHub Digital Marketing Automation OS
-- Database Schema: zethub_marketing_os
-- MySQL 5.7+ / 8.0+ / MariaDB 10.1+

CREATE DATABASE IF NOT EXISTS zethub_marketing_os CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE zethub_marketing_os;

-- 1. Users
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(190) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'admin',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Roles
CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    permissions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. Settings (Global Config & Operating Modes)
CREATE TABLE IF NOT EXISTS settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT NOT NULL,
    description VARCHAR(255),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 4. Platforms
CREATE TABLE IF NOT EXISTS platforms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    api_status VARCHAR(50) DEFAULT 'DISCONNECTED',
    config_json TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 5. Social Accounts
CREATE TABLE IF NOT EXISTS social_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    platform_id INT,
    account_name VARCHAR(150) NOT NULL,
    account_id VARCHAR(100),
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at TIMESTAMP NULL,
    is_connected BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (platform_id) REFERENCES platforms(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 6. Content Calendar
CREATE TABLE IF NOT EXISTS content_calendar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content_id VARCHAR(64) NOT NULL UNIQUE,
    topic VARCHAR(255) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    content_category VARCHAR(100) NOT NULL,
    caption TEXT,
    hashtags VARCHAR(500),
    image_prompt TEXT,
    image_url VARCHAR(1000),
    cta VARCHAR(255),
    target_audience VARCHAR(255),
    scheduled_at DATETIME NULL,
    approval_status ENUM('DRAFT', 'APPROVED', 'REJECTED') DEFAULT 'DRAFT',
    publishing_status ENUM('IDEA', 'DRAFTED', 'RENDERED', 'READY', 'SCHEDULED', 'PUBLISHING', 'PUBLISHED', 'FAILED', 'CANCELLED') DEFAULT 'IDEA',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_scheduled_status (scheduled_at, publishing_status),
    INDEX idx_platform (platform)
) ENGINE=InnoDB;

-- 7. Generated Content
CREATE TABLE IF NOT EXISTS generated_content (
    id INT AUTO_INCREMENT PRIMARY KEY,
    calendar_id INT NOT NULL,
    platform VARCHAR(50) NOT NULL,
    topic VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    raw_ai_response MEDIUMTEXT,
    parsed_caption TEXT,
    parsed_hashtags VARCHAR(500),
    qa_status ENUM('PENDING', 'PASSED', 'FAILED') DEFAULT 'PENDING',
    qa_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (calendar_id) REFERENCES content_calendar(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. Media Assets
CREATE TABLE IF NOT EXISTS media_assets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    calendar_id INT,
    template_name VARCHAR(100) NOT NULL,
    headline VARCHAR(255),
    subtext TEXT,
    format VARCHAR(20) DEFAULT '1080x1350',
    local_path VARCHAR(500),
    public_url VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (calendar_id) REFERENCES content_calendar(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 9. Publishing Queue
CREATE TABLE IF NOT EXISTS publishing_queue (
    id INT AUTO_INCREMENT PRIMARY KEY,
    calendar_id INT NOT NULL,
    platform VARCHAR(50) NOT NULL,
    scheduled_time DATETIME NOT NULL,
    retry_count INT DEFAULT 0,
    last_error TEXT,
    status ENUM('QUEUED', 'PROCESSING', 'COMPLETED', 'FAILED') DEFAULT 'QUEUED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (calendar_id) REFERENCES content_calendar(id) ON DELETE CASCADE,
    INDEX idx_queue_scheduled (scheduled_time, status)
) ENGINE=InnoDB;

-- 10. Publishing Logs
CREATE TABLE IF NOT EXISTS publishing_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    calendar_id INT,
    platform VARCHAR(50) NOT NULL,
    platform_post_id VARCHAR(150),
    post_url VARCHAR(1000),
    request_payload MEDIUMTEXT,
    response_payload MEDIUMTEXT,
    status ENUM('SUCCESS', 'FAILED') NOT NULL,
    error_message TEXT,
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (calendar_id) REFERENCES content_calendar(id) ON DELETE SET NULL,
    INDEX idx_pub_platform (platform, published_at)
) ENGINE=InnoDB;

-- 11. SEO Keywords
CREATE TABLE IF NOT EXISTS seo_keywords (
    id INT AUTO_INCREMENT PRIMARY KEY,
    keyword VARCHAR(190) NOT NULL UNIQUE,
    search_intent VARCHAR(100) DEFAULT 'Informational',
    monthly_volume INT DEFAULT 0,
    difficulty VARCHAR(50) DEFAULT 'Medium',
    priority ENUM('LOW', 'MEDIUM', 'HIGH') DEFAULT 'MEDIUM',
    target_url VARCHAR(500),
    status ENUM('DISCOVERED', 'PLANNED', 'DRAFTED', 'PUBLISHED') DEFAULT 'DISCOVERED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 12. SEO Audits
CREATE TABLE IF NOT EXISTS seo_audits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    url VARCHAR(500) NOT NULL,
    title VARCHAR(255),
    meta_description TEXT,
    h1_tags TEXT,
    broken_links TEXT,
    performance_score INT DEFAULT 0,
    audit_report_json MEDIUMTEXT,
    audited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 13. Blog Posts
CREATE TABLE IF NOT EXISTS blog_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    keyword_id INT,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(190) NOT NULL UNIQUE,
    meta_description TEXT,
    outline_json MEDIUMTEXT,
    markdown_content MEDIUMTEXT,
    faq_schema_json MEDIUMTEXT,
    internal_links_json TEXT,
    status ENUM('DRAFT', 'SCHEDULED', 'PUBLISHED') DEFAULT 'DRAFT',
    github_commit_sha VARCHAR(100),
    published_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (keyword_id) REFERENCES seo_keywords(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 14. Lead Sources
CREATE TABLE IF NOT EXISTS lead_sources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    source_name VARCHAR(100) NOT NULL UNIQUE,
    source_type VARCHAR(50) DEFAULT 'WEB_FORM',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 15. Leads (CRM)
CREATE TABLE IF NOT EXISTS leads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(190) NOT NULL,
    phone VARCHAR(50),
    company VARCHAR(150),
    industry VARCHAR(100),
    message TEXT,
    source VARCHAR(100) DEFAULT 'Website Contact Form',
    consent BOOLEAN NOT NULL DEFAULT TRUE,
    lead_score INT DEFAULT 0,
    category ENUM('HOT', 'WARM', 'COLD') DEFAULT 'WARM',
    status ENUM('NEW', 'QUALIFIED', 'CONTACTED', 'FOLLOW_UP', 'CONVERTED', 'LOST', 'UNSUBSCRIBED') DEFAULT 'NEW',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_lead_email (email),
    INDEX idx_lead_status (status)
) ENGINE=InnoDB;

-- 16. Campaigns
CREATE TABLE IF NOT EXISTS campaigns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    campaign_type VARCHAR(50) DEFAULT 'NEWSLETTER',
    target_segment VARCHAR(100) DEFAULT 'ALL',
    subject_line VARCHAR(255),
    content_html MEDIUMTEXT,
    status ENUM('DRAFT', 'SCHEDULED', 'SENT', 'FAILED') DEFAULT 'DRAFT',
    scheduled_at DATETIME NULL,
    sent_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 17. Email Contacts
CREATE TABLE IF NOT EXISTS email_contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(190) NOT NULL UNIQUE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    company VARCHAR(150),
    consent BOOLEAN NOT NULL DEFAULT TRUE,
    unsubscribed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 18. Email Suppressions
CREATE TABLE IF NOT EXISTS email_suppressions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(190) NOT NULL UNIQUE,
    reason VARCHAR(255) DEFAULT 'User Unsubscribed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 19. Competitors
CREATE TABLE IF NOT EXISTS competitors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    website VARCHAR(255),
    social_urls_json TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 20. Competitor Activity
CREATE TABLE IF NOT EXISTS competitor_activity (
    id INT AUTO_INCREMENT PRIMARY KEY,
    competitor_id INT,
    activity_type VARCHAR(100) DEFAULT 'BLOG_POST',
    title VARCHAR(255),
    content_summary TEXT,
    source_url VARCHAR(500),
    observed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (competitor_id) REFERENCES competitors(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 21. Daily Analytics
CREATE TABLE IF NOT EXISTS analytics_daily (
    id INT AUTO_INCREMENT PRIMARY KEY,
    record_date DATE NOT NULL,
    platform VARCHAR(50) NOT NULL,
    metric_name VARCHAR(100) NOT NULL,
    metric_value DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    metadata_json TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_date_plat_metric (record_date, platform, metric_name),
    INDEX idx_analytics_date (record_date)
) ENGINE=InnoDB;

-- 22. Marketing Reports
CREATE TABLE IF NOT EXISTS marketing_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_type ENUM('DAILY', 'WEEKLY', 'MONTHLY') NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    summary_text MEDIUMTEXT,
    recommendations_text MEDIUMTEXT,
    metrics_json MEDIUMTEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 23. Automation Workflows
CREATE TABLE IF NOT EXISTS automation_workflows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    workflow_code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    trigger_schedule VARCHAR(100) DEFAULT 'Manual',
    last_run_at DATETIME NULL,
    next_run_at DATETIME NULL,
    status VARCHAR(50) DEFAULT 'IDLE'
) ENGINE=InnoDB;

-- 24. Automation Executions
CREATE TABLE IF NOT EXISTS automation_executions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    workflow_code VARCHAR(100) NOT NULL,
    status ENUM('RUNNING', 'SUCCESS', 'FAILED') DEFAULT 'RUNNING',
    input_payload MEDIUMTEXT,
    output_payload MEDIUMTEXT,
    error_details TEXT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP NULL,
    INDEX idx_exec_wf (workflow_code, started_at)
) ENGINE=InnoDB;

-- 25. AI Requests
CREATE TABLE IF NOT EXISTS ai_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    agent_name VARCHAR(100) NOT NULL,
    prompt_system MEDIUMTEXT,
    prompt_user MEDIUMTEXT,
    model VARCHAR(50) DEFAULT 'auto',
    provider VARCHAR(50) DEFAULT 'vireonix',
    tokens_used INT DEFAULT 0,
    duration_ms INT DEFAULT 0,
    status ENUM('SUCCESS', 'FAILED') DEFAULT 'SUCCESS',
    response_text MEDIUMTEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_ai_agent (agent_name, created_at)
) ENGINE=InnoDB;

-- 26. System Logs
CREATE TABLE IF NOT EXISTS system_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    level ENUM('INFO', 'WARN', 'ERROR', 'CRITICAL') DEFAULT 'INFO',
    source VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    context_json MEDIUMTEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_log_level (level, created_at)
) ENGINE=InnoDB;
