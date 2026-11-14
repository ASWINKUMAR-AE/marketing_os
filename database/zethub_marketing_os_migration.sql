-- MySQL dump 10.16  Distrib 10.1.21-MariaDB, for Win32 (AMD64)
--
-- Host: 127.0.0.1    Database: 127.0.0.1
-- ------------------------------------------------------
-- Server version	10.1.21-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `zethub_marketing_os`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `zethub_marketing_os` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `zethub_marketing_os`;

--
-- Table structure for table `ai_requests`
--

DROP TABLE IF EXISTS `ai_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ai_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prompt_system` mediumtext COLLATE utf8mb4_unicode_ci,
  `prompt_user` mediumtext COLLATE utf8mb4_unicode_ci,
  `model` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'auto',
  `provider` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'vireonix',
  `tokens_used` int(11) DEFAULT '0',
  `duration_ms` int(11) DEFAULT '0',
  `status` enum('SUCCESS','FAILED') COLLATE utf8mb4_unicode_ci DEFAULT 'SUCCESS',
  `response_text` mediumtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ai_agent` (`agent_name`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_requests`
--

LOCK TABLES `ai_requests` WRITE;
/*!40000 ALTER TABLE `ai_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `analytics_daily`
--

DROP TABLE IF EXISTS `analytics_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_daily` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_date` date NOT NULL,
  `platform` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `metric_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `metric_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `metadata_json` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_date_plat_metric` (`record_date`,`platform`,`metric_name`),
  KEY `idx_analytics_date` (`record_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analytics_daily`
--

LOCK TABLES `analytics_daily` WRITE;
/*!40000 ALTER TABLE `analytics_daily` DISABLE KEYS */;
/*!40000 ALTER TABLE `analytics_daily` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `automation_executions`
--

DROP TABLE IF EXISTS `automation_executions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `automation_executions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('RUNNING','SUCCESS','FAILED') COLLATE utf8mb4_unicode_ci DEFAULT 'RUNNING',
  `input_payload` mediumtext COLLATE utf8mb4_unicode_ci,
  `output_payload` mediumtext COLLATE utf8mb4_unicode_ci,
  `error_details` text COLLATE utf8mb4_unicode_ci,
  `started_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `finished_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_exec_wf` (`workflow_code`,`started_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automation_executions`
--

LOCK TABLES `automation_executions` WRITE;
/*!40000 ALTER TABLE `automation_executions` DISABLE KEYS */;
/*!40000 ALTER TABLE `automation_executions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `automation_workflows`
--

DROP TABLE IF EXISTS `automation_workflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `automation_workflows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `trigger_schedule` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'Manual',
  `last_run_at` datetime DEFAULT NULL,
  `next_run_at` datetime DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'IDLE',
  PRIMARY KEY (`id`),
  UNIQUE KEY `workflow_code` (`workflow_code`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automation_workflows`
--

LOCK TABLES `automation_workflows` WRITE;
/*!40000 ALTER TABLE `automation_workflows` DISABLE KEYS */;
INSERT INTO `automation_workflows` VALUES (1,'WF00_AI_GATEWAY','AI Gateway & Fallback Router',1,'Sub-workflow',NULL,NULL,'ACTIVE'),(2,'WF01_AI_MARKETING_MANAGER','AI Marketing Manager & Strategy Planner',1,'Daily 07:00 IST',NULL,NULL,'ACTIVE'),(3,'WF02_CONTENT_FACTORY','AI Social & Educational Content Factory',1,'Daily 08:00 IST',NULL,NULL,'ACTIVE'),(4,'WF03_MEDIA_FACTORY','Creative Media & Image Renderer Service',1,'On Content Ready',NULL,NULL,'ACTIVE'),(5,'WF04_SOCIAL_PUBLISHER','Social Media Publishing & Queue Engine',1,'Every 30 Mins',NULL,NULL,'APPROVAL_MODE'),(6,'WF05_SEO_AUTOMATION','SEO Crawler, Audit & Keyword Intelligence',1,'Daily 14:00 IST',NULL,NULL,'ACTIVE'),(7,'WF06_BLOG_AUTOMATION','AI Technical Blog & Article Engine',1,'Tue, Thu 16:00 IST',NULL,NULL,'ACTIVE'),(8,'WF07_LEAD_GENERATION_CRM','AI Inbound Lead Intake & CRM Scoring',1,'On Inbound Lead / 5m Poll',NULL,NULL,'ACTIVE'),(9,'WF08_EMAIL_MARKETING','AI Newsletter & Nurture Campaign Engine',1,'Weekly Fri 10:00 IST',NULL,NULL,'ACTIVE'),(10,'WF09_ANALYTICS_REPORTS','Multi-Platform Analytics & Report Generator',1,'Daily 20:00 IST',NULL,NULL,'ACTIVE'),(11,'WF10_ERROR_MONITOR','System Watchdog & Telegram Alert Monitor',1,'Every 15 Mins',NULL,NULL,'ACTIVE');
/*!40000 ALTER TABLE `automation_workflows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_posts`
--

DROP TABLE IF EXISTS `blog_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blog_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyword_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_description` text COLLATE utf8mb4_unicode_ci,
  `outline_json` mediumtext COLLATE utf8mb4_unicode_ci,
  `markdown_content` mediumtext COLLATE utf8mb4_unicode_ci,
  `faq_schema_json` mediumtext COLLATE utf8mb4_unicode_ci,
  `internal_links_json` text COLLATE utf8mb4_unicode_ci,
  `status` enum('DRAFT','SCHEDULED','PUBLISHED') COLLATE utf8mb4_unicode_ci DEFAULT 'DRAFT',
  `github_commit_sha` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `published_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `keyword_id` (`keyword_id`),
  CONSTRAINT `blog_posts_ibfk_1` FOREIGN KEY (`keyword_id`) REFERENCES `seo_keywords` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_posts`
--

LOCK TABLES `blog_posts` WRITE;
/*!40000 ALTER TABLE `blog_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `campaigns`
--

DROP TABLE IF EXISTS `campaigns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `campaigns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `campaign_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'NEWSLETTER',
  `target_segment` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'ALL',
  `subject_line` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content_html` mediumtext COLLATE utf8mb4_unicode_ci,
  `status` enum('DRAFT','SCHEDULED','SENT','FAILED') COLLATE utf8mb4_unicode_ci DEFAULT 'DRAFT',
  `scheduled_at` datetime DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `campaigns`
--

LOCK TABLES `campaigns` WRITE;
/*!40000 ALTER TABLE `campaigns` DISABLE KEYS */;
INSERT INTO `campaigns` VALUES (1,'Weekly Tech Pulse - 2026-11-14','NEWSLETTER','ALL','Stop Guessing: Fix Inventory Errors in 15 Mins & Scale with Practical AI','<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n    <meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <title>ZetHub Tech Pulse</title>\n</head>\n<body style=\"margin:0; padding:0; background-color:#f4f4f4; font-family:Arial, sans-serif;\">\n    <div style=\"max-width:600px; margin:0 auto; background-color:#ffffff;\">\n        <!-- Header -->\n        <div style=\"background-color:#0a192f; padding:20px; text-align:center;\">\n            <h1 style=\"color:#ffffff; font-size:24px; margin:0;\">The ZetHub Tech Pulse</h1>\n            <p style=\"color:#a8b2d1; font-size:14px; margin:5px 0 0 0;\">Your weekly dose of practical AI & Automation</p>\n        </div>\n\n        <!-- Feature Story -->\n        <div style=\"padding:30px;\">\n            <h2 style=\"color:#0a192f; font-size:20px; margin-bottom:10px;\">Feature Story: Accelerating Indian Enterprises with Practical AI Automation</h2>\n            <p style=\"color:#333333; font-size:16px; line-height:1.6; margin-bottom:15px;\">\n                Many Indian businesses are stuck in a \'pilot purgatory\'—building AI demos that never make it to production. The gap isn\'t technology; it\'s architecture.\n            </p>\n            <p style=\"color:#333333; font-size:16px; line-height:1.6; margin-bottom:15px;\">\n                This week, we dive into how leading mid-sized enterprises are bypassing complex, over-engineered AI stacks in favor of <strong>pragmatic, modular automation</strong>. By integrating lightweight AI agents with existing ERP and inventory systems, companies are seeing a 30% reduction in operational overhead without requiring a full tech stack overhaul. The key? Focusing on high-friction, low-complexity workflows first.\n            </p>\n        </div>\n\n        <!-- Tech Tip -->\n        <div style=\"background-color:#f8f9fa; padding:30px; border-left:4px solid #0a192f;\">\n            <h3 style=\"color:#0a192f; font-size:18px; margin-bottom:10px;\">Tech Tip of the Week: Eliminating Inventory Spreadsheet Errors</h3>\n            <p style=\"color:#333333; font-size:16px; line-height:1.6; margin-bottom:15px;\">\n                <strong>Problem:</strong> Manual data entry in inventory spreadsheets leads to stockouts and overstocking.\n            </p>\n            <p style=\"color:#333333; font-size:16px; line-height:1.6; margin-bottom:15px;\">\n                <strong>15-Min Fix:</strong> Instead of manually copying data, use a simple Python script (or a Zapier/Make.com integration) to pull data directly from your POS or ERP API into your spreadsheet or database. \n            </p>\n            <p style=\"color:#333333; font-size:16px; line-height:1.6;\">\n                <em>Implementation:</em> Set up a nightly cron job that fetches the \'inventory_status\' endpoint and appends it to a CSV. This eliminates 100% of human transcription errors and gives you a real-time audit trail.\n            </p>\n        </div>\n\n        <!-- Engineering Update -->\n        <div style=\"padding:30px;\">\n            <h3 style=\"color:#0a192f; font-size:18px; margin-bottom:10px;\">ZetHub Engineering Update</h3>\n            <p style=\"color:#333333; font-size:16px; line-height:1.6;\">\n                Our team recently deployed a new <strong>AI-driven anomaly detection module</strong> for a manufacturing client. By analyzing real-time sensor data, we reduced unscheduled downtime by 22% in the first month. We’re now open-sourcing our initial data preprocessing pipeline to help other teams start their automation journey faster.\n            </p>\n        </div>\n\n        <!-- CTA -->\n        <div style=\"padding:30px; text-align:center; background-color:#0a192f;\">\n            <h3 style=\"color:#ffffff; font-size:20px; margin-bottom:15px;\">Ready to stop guessing and start automating?</h3>\n            <a href=\"https://zethub.in\" style=\"display:inline-block; background-color:#64ffda; color:#0a192f; text-decoration:none; padding:15px 30px; border-radius:5px; font-weight:bold; font-size:16px;\">Book an AI Architecture Audit</a>\n        </div>\n\n        <!-- Footer -->\n        <div style=\"padding:20px; text-align:center; background-color:#e2e8f0;\">\n            <p style=\"color:#64748b; font-size:12px; margin-bottom:10px;\">\n                You are receiving this email because you subscribed to The ZetHub Tech Pulse.\n            </p>\n            <a href=\"{{unsubscribe_url}}\" style=\"color:#64748b; font-size:12px; text-decoration:underline;\">Unsubscribe</a>\n            <p style=\"color:#64748b; font-size:12px; margin-top:10px;\">© 2023 ZetHub. All rights reserved.</p>\n        </div>\n    </div>\n</body>\n</html>','DRAFT',NULL,NULL,'2026-11-14 05:22:31'),(2,'Weekly Tech Pulse - 2026-11-14','NEWSLETTER','ALL','Stop Chasing Spreadsheets: AI Automation for Indian Enterprises','<div style=\"font-family:Arial, sans-serif; max-width:600px; margin:0 auto; background-color:#ffffff;\">\n  <div style=\"background-color:#0f172a; padding:20px; text-align:center;\">\n    <h1 style=\"color:#ffffff; margin:0; font-size:24px;\">The ZetHub Tech Pulse</h1>\n    <p style=\"color:#94a3b8; font-size:14px; margin:5px 0 0 0;\">Weekly insights for founders & engineers</p>\n  </div>\n  \n  <div style=\"padding:30px;\">\n    <h2 style=\"color:#0f172a; font-size:20px; margin-bottom:10px;\">Feature: Accelerating Indian Enterprises with Practical AI Automation</h2>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:20px;\">Most Indian enterprises don\'t fail due to lack of AI, but due to implementation friction. We\'re seeing a shift from \'hype\' to \'utility.\' In this week\'s deep dive, we explore how mid-sized logistics and retail firms are using lightweight AI agents to automate invoice reconciliation and demand forecasting. The key? It\'s not about building a custom LLM; it\'s about integrating existing models into your existing ERP workflows with minimal code. We break down the architecture pattern that reduced operational latency by 40% for one of our clients in Mumbai.</p>\n    \n    <hr style=\"border:0; height:1px; background:#e2e8f0; margin:30px 0;\" />\n    \n    <h2 style=\"color:#0f172a; font-size:20px; margin-bottom:10px;\">Tip of the Week: Eliminating Inventory Spreadsheet Errors</h2>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:10px;\"><strong>Implementable in under 15 minutes:</strong></p>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:10px;\">Stop manually cross-referencing purchase orders and stock levels in Excel. Here’s a quick win:\n    <br><br>\n    1. <strong>Export</strong> your current inventory CSV and PO CSV.\n    2. <strong>Use a simple Python script</strong> (or a low-code tool like Make.com) to join these two files on \'SKU_ID\'.\n    3. <strong>Flag Discrepancies:</strong> Create a rule: If `PO_Qty > Current_Stock + Safety_Stock`, flag as \'Overstock Risk\'; if `PO_Qty < 0`, flag as \'Data Error\'.\n    4. <strong>Automate the Alert:</strong> Connect the output to a Slack or Teams webhook to notify your ops team immediately.\n    <br><br>\n    This removes 95% of human error in stock planning and takes less than 15 minutes to set up the initial pipeline.</p>\n\n    <hr style=\"border:0; height:1px; background:#e2e8f0; margin:30px 0;\" />\n\n    <h2 style=\"color:#0f172a; font-size:20px; margin-bottom:10px;\">ZetHub Engineering Update</h2>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:20px;\">We recently deployed a new RAG (Retrieval-Augmented Generation) pipeline for a fintech client, reducing hallucination rates in their customer support bot by 60% while maintaining sub-200ms latency. We’re excited to share the technical details in our next engineering blog post.</p>\n\n    <div style=\"background-color:#f1f5f9; padding:20px; border-radius:8px; text-align:center; margin-top:20px;\">\n      <h3 style=\"color:#0f172a; font-size:18px; margin-bottom:10px;\">Ready to scale your operations?</h3>\n      <p style=\"color:#475569; font-size:16px; margin-bottom:15px;\">Book an AI Architecture Audit to find your biggest automation wins.</p>\n      <a href=\"https://zethub.in\" style=\"background-color:#0f172a; color:#ffffff; padding:12px 24px; text-decoration:none; border-radius:6px; font-weight:bold; display:inline-block;\">Book Your Audit Now</a>\n    </div>\n  </div>\n\n  <div style=\"background-color:#f8fafc; padding:20px; text-align:center;\">\n    <p style=\"color:#94a3b8; font-size:12px; margin:0;\">You are receiving this email because you opted in at zethub.in.</p>\n    <p style=\"color:#94a3b8; font-size:12px; margin:5px 0 0 0;\">Unsubscribe: <a href=\"{{unsubscribe_url}}\" style=\"color:#64748b; text-decoration:underline;\">Click here</a></p>\n  </div>\n</div>','DRAFT',NULL,NULL,'2026-11-14 05:22:41'),(3,'Weekly Tech Pulse - 2026-11-14','NEWSLETTER','ALL','Stop Chasing Spreadsheets: AI Automation for Indian Enterprises','<div style=\"font-family:Arial, sans-serif; max-width:600px; margin:0 auto; background-color:#ffffff;\">\n  <div style=\"background-color:#0f172a; padding:20px; text-align:center;\">\n    <h1 style=\"color:#ffffff; margin:0; font-size:24px;\">The ZetHub Tech Pulse</h1>\n    <p style=\"color:#94a3b8; font-size:14px; margin:5px 0 0 0;\">Weekly insights for founders & engineers</p>\n  </div>\n  \n  <div style=\"padding:30px;\">\n    <h2 style=\"color:#0f172a; font-size:20px; margin-bottom:10px;\">Feature: Accelerating Indian Enterprises with Practical AI Automation</h2>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:20px;\">Most Indian enterprises don\'t fail due to lack of AI, but due to implementation friction. We\'re seeing a shift from \'hype\' to \'utility.\' In this week\'s deep dive, we explore how mid-sized logistics and retail firms are using lightweight AI agents to automate invoice reconciliation and demand forecasting. The key? It\'s not about building a custom LLM; it\'s about integrating existing models into your existing ERP workflows with minimal code. We break down the architecture pattern that reduced operational latency by 40% for one of our clients in Mumbai.</p>\n    \n    <hr style=\"border:0; height:1px; background:#e2e8f0; margin:30px 0;\" />\n    \n    <h2 style=\"color:#0f172a; font-size:20px; margin-bottom:10px;\">Tip of the Week: Eliminating Inventory Spreadsheet Errors</h2>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:10px;\"><strong>Implementable in under 15 minutes:</strong></p>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:10px;\">Stop manually cross-referencing purchase orders and stock levels in Excel. Here’s a quick win:\n    <br><br>\n    1. <strong>Export</strong> your current inventory CSV and PO CSV.\n    2. <strong>Use a simple Python script</strong> (or a low-code tool like Make.com) to join these two files on \'SKU_ID\'.\n    3. <strong>Flag Discrepancies:</strong> Create a rule: If `PO_Qty > Current_Stock + Safety_Stock`, flag as \'Overstock Risk\'; if `PO_Qty < 0`, flag as \'Data Error\'.\n    4. <strong>Automate the Alert:</strong> Connect the output to a Slack or Teams webhook to notify your ops team immediately.\n    <br><br>\n    This removes 95% of human error in stock planning and takes less than 15 minutes to set up the initial pipeline.</p>\n\n    <hr style=\"border:0; height:1px; background:#e2e8f0; margin:30px 0;\" />\n\n    <h2 style=\"color:#0f172a; font-size:20px; margin-bottom:10px;\">ZetHub Engineering Update</h2>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:20px;\">We recently deployed a new RAG (Retrieval-Augmented Generation) pipeline for a fintech client, reducing hallucination rates in their customer support bot by 60% while maintaining sub-200ms latency. We’re excited to share the technical details in our next engineering blog post.</p>\n\n    <div style=\"background-color:#f1f5f9; padding:20px; border-radius:8px; text-align:center; margin-top:20px;\">\n      <h3 style=\"color:#0f172a; font-size:18px; margin-bottom:10px;\">Ready to scale your operations?</h3>\n      <p style=\"color:#475569; font-size:16px; margin-bottom:15px;\">Book an AI Architecture Audit to find your biggest automation wins.</p>\n      <a href=\"https://zethub.in\" style=\"background-color:#0f172a; color:#ffffff; padding:12px 24px; text-decoration:none; border-radius:6px; font-weight:bold; display:inline-block;\">Book Your Audit Now</a>\n    </div>\n  </div>\n\n  <div style=\"background-color:#f8fafc; padding:20px; text-align:center;\">\n    <p style=\"color:#94a3b8; font-size:12px; margin:0;\">You are receiving this email because you opted in at zethub.in.</p>\n    <p style=\"color:#94a3b8; font-size:12px; margin:5px 0 0 0;\">Unsubscribe: <a href=\"{{unsubscribe_url}}\" style=\"color:#64748b; text-decoration:underline;\">Click here</a></p>\n  </div>\n</div>','DRAFT',NULL,NULL,'2026-11-14 05:28:26'),(4,'Weekly Tech Pulse - 2026-11-14','NEWSLETTER','ALL','Stop Chasing Spreadsheets: AI Automation for Indian Enterprises','<div style=\"font-family:Arial, sans-serif; max-width:600px; margin:0 auto; background-color:#ffffff;\">\n  <div style=\"background-color:#0f172a; padding:20px; text-align:center;\">\n    <h1 style=\"color:#ffffff; margin:0; font-size:24px;\">The ZetHub Tech Pulse</h1>\n    <p style=\"color:#94a3b8; font-size:14px; margin:5px 0 0 0;\">Weekly insights for founders & engineers</p>\n  </div>\n  \n  <div style=\"padding:30px;\">\n    <h2 style=\"color:#0f172a; font-size:20px; margin-bottom:10px;\">Feature: Accelerating Indian Enterprises with Practical AI Automation</h2>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:20px;\">Most Indian enterprises don\'t fail due to lack of AI, but due to implementation friction. We\'re seeing a shift from \'hype\' to \'utility.\' In this week\'s deep dive, we explore how mid-sized logistics and retail firms are using lightweight AI agents to automate invoice reconciliation and demand forecasting. The key? It\'s not about building a custom LLM; it\'s about integrating existing models into your existing ERP workflows with minimal code. We break down the architecture pattern that reduced operational latency by 40% for one of our clients in Mumbai.</p>\n    \n    <hr style=\"border:0; height:1px; background:#e2e8f0; margin:30px 0;\" />\n    \n    <h2 style=\"color:#0f172a; font-size:20px; margin-bottom:10px;\">Tip of the Week: Eliminating Inventory Spreadsheet Errors</h2>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:10px;\"><strong>Implementable in under 15 minutes:</strong></p>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:10px;\">Stop manually cross-referencing purchase orders and stock levels in Excel. Here’s a quick win:\n    <br><br>\n    1. <strong>Export</strong> your current inventory CSV and PO CSV.\n    2. <strong>Use a simple Python script</strong> (or a low-code tool like Make.com) to join these two files on \'SKU_ID\'.\n    3. <strong>Flag Discrepancies:</strong> Create a rule: If `PO_Qty > Current_Stock + Safety_Stock`, flag as \'Overstock Risk\'; if `PO_Qty < 0`, flag as \'Data Error\'.\n    4. <strong>Automate the Alert:</strong> Connect the output to a Slack or Teams webhook to notify your ops team immediately.\n    <br><br>\n    This removes 95% of human error in stock planning and takes less than 15 minutes to set up the initial pipeline.</p>\n\n    <hr style=\"border:0; height:1px; background:#e2e8f0; margin:30px 0;\" />\n\n    <h2 style=\"color:#0f172a; font-size:20px; margin-bottom:10px;\">ZetHub Engineering Update</h2>\n    <p style=\"color:#475569; font-size:16px; line-height:1.6; margin-bottom:20px;\">We recently deployed a new RAG (Retrieval-Augmented Generation) pipeline for a fintech client, reducing hallucination rates in their customer support bot by 60% while maintaining sub-200ms latency. We’re excited to share the technical details in our next engineering blog post.</p>\n\n    <div style=\"background-color:#f1f5f9; padding:20px; border-radius:8px; text-align:center; margin-top:20px;\">\n      <h3 style=\"color:#0f172a; font-size:18px; margin-bottom:10px;\">Ready to scale your operations?</h3>\n      <p style=\"color:#475569; font-size:16px; margin-bottom:15px;\">Book an AI Architecture Audit to find your biggest automation wins.</p>\n      <a href=\"https://zethub.in\" style=\"background-color:#0f172a; color:#ffffff; padding:12px 24px; text-decoration:none; border-radius:6px; font-weight:bold; display:inline-block;\">Book Your Audit Now</a>\n    </div>\n  </div>\n\n  <div style=\"background-color:#f8fafc; padding:20px; text-align:center;\">\n    <p style=\"color:#94a3b8; font-size:12px; margin:0;\">You are receiving this email because you opted in at zethub.in.</p>\n    <p style=\"color:#94a3b8; font-size:12px; margin:5px 0 0 0;\">Unsubscribe: <a href=\"{{unsubscribe_url}}\" style=\"color:#64748b; text-decoration:underline;\">Click here</a></p>\n  </div>\n</div>','DRAFT',NULL,NULL,'2026-11-14 05:28:41');
/*!40000 ALTER TABLE `campaigns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `competitor_activity`
--

DROP TABLE IF EXISTS `competitor_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `competitor_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `competitor_id` int(11) DEFAULT NULL,
  `activity_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'BLOG_POST',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content_summary` text COLLATE utf8mb4_unicode_ci,
  `source_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `competitor_id` (`competitor_id`),
  CONSTRAINT `competitor_activity_ibfk_1` FOREIGN KEY (`competitor_id`) REFERENCES `competitors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competitor_activity`
--

LOCK TABLES `competitor_activity` WRITE;
/*!40000 ALTER TABLE `competitor_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `competitor_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `competitors`
--

DROP TABLE IF EXISTS `competitors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `competitors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `social_urls_json` text COLLATE utf8mb4_unicode_ci,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competitors`
--

LOCK TABLES `competitors` WRITE;
/*!40000 ALTER TABLE `competitors` DISABLE KEYS */;
INSERT INTO `competitors` VALUES (1,'Freshworks','https://www.freshworks.com',NULL,'Major Indian SaaS leader in CRM and IT services','2026-11-14 03:56:02'),(2,'Zoho','https://www.zoho.com',NULL,'Dominant SaaS and business operating system suite from Tamil Nadu','2026-11-14 03:56:02'),(5,'TestCompetitor','https://test.com',NULL,'Test notes','2026-11-14 04:31:42');
/*!40000 ALTER TABLE `competitors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_calendar`
--

DROP TABLE IF EXISTS `content_calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_calendar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `topic` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `platform` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_category` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption` text COLLATE utf8mb4_unicode_ci,
  `hashtags` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_prompt` text COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cta` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target_audience` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  `approval_status` enum('DRAFT','APPROVED','REJECTED') COLLATE utf8mb4_unicode_ci DEFAULT 'DRAFT',
  `publishing_status` enum('IDEA','DRAFTED','RENDERED','READY','SCHEDULED','PUBLISHING','PUBLISHED','FAILED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'IDEA',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_id` (`content_id`),
  KEY `idx_scheduled_status` (`scheduled_at`,`publishing_status`),
  KEY `idx_platform` (`platform`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_calendar`
--

LOCK TABLES `content_calendar` WRITE;
/*!40000 ALTER TABLE `content_calendar` DISABLE KEYS */;
INSERT INTO `content_calendar` VALUES (1,'ZH-A5DC15CD','Why Indian textile manufacturers are adopting AI workflow automation in 2026','LinkedIn','Educational','Most Indian textile manufacturers still treat automation as a cost center. They buy a machine, install it, and walk away.\n\nBut here is the harsh reality: The bottleneck isn\'t the machinery. It’s the data gap.\n\nIn a typical mill, 40% of time is lost to manual data entry, delayed quality checks, and reactive maintenance. When you scale, these inefficiencies compound exponentially.\n\nIn 2026, the winning strategy isn\'t just \'smart machines.\' It’s intelligent workflows.\n\nHere’s what AI workflow automation actually fixes:\n\n• Predictive Maintenance: AI analyzes spindle vibration and temperature to predict failures before they stop production. No more unscheduled downtime.\n\n• Real-Time Quality Control: Computer vision models flag fabric defects in milliseconds, not hours. This reduces waste by up to 15%.\n\n• Supply Chain Sync: AI links raw material inventory with production schedules, ensuring you never over-order or run dry.\n\n• Automated Reporting: No more end-of-day manual reports. Data flows directly from the floor to the boardroom dashboard.\n\nThe ROI? \n\nA mid-sized mill we recently worked with reduced downtime by 22% and cut quality rejection rates by 18% within 6 months. The system paid for itself in 4 months.\n\nThis isn\'t science fiction. It’s operational survival.\n\nIf you are still relying on Excel sheets and manual logs to run a multi-million rupee operation, you are competing with a handicap.\n\nThe future of Indian textiles belongs to those who automate the workflow, not just the machine.','#TextileIndustry #AIinManufacturing #OperationalExcellence #ZetHub #IndiaTech','Template: tip','http://localhost:5001/images/tip_77d0e86b.png','Ready to map your factory’s automation potential? Book a free technical audit with ZetHub today.','Indian SMEs & Founders','2026-11-14 09:46:29','DRAFT','PUBLISHED','2026-11-14 04:16:29','2026-11-14 05:28:45');
/*!40000 ALTER TABLE `content_calendar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_contacts`
--

DROP TABLE IF EXISTS `email_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `consent` tinyint(1) NOT NULL DEFAULT '1',
  `unsubscribed` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_contacts`
--

LOCK TABLES `email_contacts` WRITE;
/*!40000 ALTER TABLE `email_contacts` DISABLE KEYS */;
INSERT INTO `email_contacts` VALUES (1,'murugan@maduraitextiles.com','Murugan Vel',NULL,'Madurai Textiles & Garments',1,0,'2026-11-14 04:16:48'),(2,'testprospect@example.com','API Test Prospect',NULL,'Test Garments Ltd',1,0,'2026-11-14 04:31:41'),(3,'sec@example.com','Security Tester',NULL,'Secure Inc',1,0,'2026-11-14 04:31:52');
/*!40000 ALTER TABLE `email_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_suppressions`
--

DROP TABLE IF EXISTS `email_suppressions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_suppressions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'User Unsubscribed',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_suppressions`
--

LOCK TABLES `email_suppressions` WRITE;
/*!40000 ALTER TABLE `email_suppressions` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_suppressions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generated_content`
--

DROP TABLE IF EXISTS `generated_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `generated_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `calendar_id` int(11) NOT NULL,
  `platform` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `topic` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `raw_ai_response` mediumtext COLLATE utf8mb4_unicode_ci,
  `parsed_caption` text COLLATE utf8mb4_unicode_ci,
  `parsed_hashtags` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qa_status` enum('PENDING','PASSED','FAILED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `qa_notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `calendar_id` (`calendar_id`),
  CONSTRAINT `generated_content_ibfk_1` FOREIGN KEY (`calendar_id`) REFERENCES `content_calendar` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_content`
--

LOCK TABLES `generated_content` WRITE;
/*!40000 ALTER TABLE `generated_content` DISABLE KEYS */;
INSERT INTO `generated_content` VALUES (1,1,'LinkedIn','Why Indian textile manufacturers are adopting AI workflow automation in 2026','Educational','{\"hook\": \"Your textile factory is bleeding money in the \'white space\' between machines. In 2026, AI workflow automation is the only way to plug it.\", \"content\": \"Most Indian textile manufacturers still treat automation as a cost center. They buy a machine, install it, and walk away.\\n\\nBut here is the harsh reality: The bottleneck isn\'t the machinery. It\\u2019s the data gap.\\n\\nIn a typical mill, 40% of time is lost to manual data entry, delayed quality checks, and reactive maintenance. When you scale, these inefficiencies compound exponentially.\\n\\nIn 2026, the winning strategy isn\'t just \'smart machines.\' It\\u2019s intelligent workflows.\\n\\nHere\\u2019s what AI workflow automation actually fixes:\\n\\n\\u2022 Predictive Maintenance: AI analyzes spindle vibration and temperature to predict failures before they stop production. No more unscheduled downtime.\\n\\n\\u2022 Real-Time Quality Control: Computer vision models flag fabric defects in milliseconds, not hours. This reduces waste by up to 15%.\\n\\n\\u2022 Supply Chain Sync: AI links raw material inventory with production schedules, ensuring you never over-order or run dry.\\n\\n\\u2022 Automated Reporting: No more end-of-day manual reports. Data flows directly from the floor to the boardroom dashboard.\\n\\nThe ROI? \\n\\nA mid-sized mill we recently worked with reduced downtime by 22% and cut quality rejection rates by 18% within 6 months. The system paid for itself in 4 months.\\n\\nThis isn\'t science fiction. It\\u2019s operational survival.\\n\\nIf you are still relying on Excel sheets and manual logs to run a multi-million rupee operation, you are competing with a handicap.\\n\\nThe future of Indian textiles belongs to those who automate the workflow, not just the machine.\", \"hashtags\": \"#TextileIndustry #AIinManufacturing #OperationalExcellence #ZetHub #IndiaTech\", \"discussion_question\": \"Where do you see the biggest \'data gap\' in your current manufacturing process?\", \"cta\": \"Ready to map your factory\\u2019s automation potential? Book a free technical audit with ZetHub today.\", \"image_creative\": {\"template\": \"tip\", \"headline\": \"Stop Automating Machines. Start Automating Workflows.\", \"subtext\": \"The 2026 Playbook for Indian Textile Leaders\", \"format\": \"1080x1080\"}}','Most Indian textile manufacturers still treat automation as a cost center. They buy a machine, install it, and walk away.\n\nBut here is the harsh reality: The bottleneck isn\'t the machinery. It’s the data gap.\n\nIn a typical mill, 40% of time is lost to manual data entry, delayed quality checks, and reactive maintenance. When you scale, these inefficiencies compound exponentially.\n\nIn 2026, the winning strategy isn\'t just \'smart machines.\' It’s intelligent workflows.\n\nHere’s what AI workflow automation actually fixes:\n\n• Predictive Maintenance: AI analyzes spindle vibration and temperature to predict failures before they stop production. No more unscheduled downtime.\n\n• Real-Time Quality Control: Computer vision models flag fabric defects in milliseconds, not hours. This reduces waste by up to 15%.\n\n• Supply Chain Sync: AI links raw material inventory with production schedules, ensuring you never over-order or run dry.\n\n• Automated Reporting: No more end-of-day manual reports. Data flows directly from the floor to the boardroom dashboard.\n\nThe ROI? \n\nA mid-sized mill we recently worked with reduced downtime by 22% and cut quality rejection rates by 18% within 6 months. The system paid for itself in 4 months.\n\nThis isn\'t science fiction. It’s operational survival.\n\nIf you are still relying on Excel sheets and manual logs to run a multi-million rupee operation, you are competing with a handicap.\n\nThe future of Indian textiles belongs to those who automate the workflow, not just the machine.','#TextileIndustry #AIinManufacturing #OperationalExcellence #ZetHub #IndiaTech','FAILED','The draft is within the 3,000-character LinkedIn limit and contains no banned phrases, fake discounts, or invented pricing. However, it is not ready to publish because the performance and ROI claims are unsubstantiated, the customer example requires verification, and the CTA, hashtag count, and tone need correction.','2026-11-14 04:16:29');
/*!40000 ALTER TABLE `generated_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lead_sources`
--

DROP TABLE IF EXISTS `lead_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lead_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'WEB_FORM',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `source_name` (`source_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lead_sources`
--

LOCK TABLES `lead_sources` WRITE;
/*!40000 ALTER TABLE `lead_sources` DISABLE KEYS */;
INSERT INTO `lead_sources` VALUES (1,'Website Inquiry Form','WEB_FORM','2026-11-14 03:56:02'),(2,'LinkedIn Inbound','SOCIAL','2026-11-14 03:56:02'),(3,'Newsletter Signup','EMAIL_OPTIN','2026-11-14 03:56:02'),(4,'Direct Referral','REFERRAL','2026-11-14 03:56:02');
/*!40000 ALTER TABLE `lead_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leads`
--

DROP TABLE IF EXISTS `leads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `industry` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `source` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'Website Contact Form',
  `consent` tinyint(1) NOT NULL DEFAULT '1',
  `lead_score` int(11) DEFAULT '0',
  `category` enum('HOT','WARM','COLD') COLLATE utf8mb4_unicode_ci DEFAULT 'WARM',
  `status` enum('NEW','QUALIFIED','CONTACTED','FOLLOW_UP','CONVERTED','LOST','UNSUBSCRIBED') COLLATE utf8mb4_unicode_ci DEFAULT 'NEW',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_lead_email` (`email`(191)),
  KEY `idx_lead_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads`
--

LOCK TABLES `leads` WRITE;
/*!40000 ALTER TABLE `leads` DISABLE KEYS */;
INSERT INTO `leads` VALUES (1,'Murugan Vel','murugan@maduraitextiles.com','+91 98420 12345','Madurai Textiles & Garments','Textile Manufacturing','We have 4 production facilities and waste 20 hours each week tracking loom output and fabric yarn stock across spreadsheets. Looking for a custom automated ERP system with real-time analytics.','Website Inbound',1,85,'HOT','NEW','AI Recommendation: Schedule a 30-minute discovery call and tailored ERP demo within 48 hours. Map the loom-output and yarn-stock workflows across all four facilities, quantify the 20-hour weekly savings, and confirm budget, implementation timeline, and key stakeholders.','2026-11-14 04:16:48','2026-11-14 04:16:48'),(2,'API Test Prospect','testprospect@example.com',NULL,'Test Garments Ltd','Textile','Interested in AI software for stock management','Website Contact Form',1,90,'HOT','QUALIFIED','AI Recommendation: Call immediately','2026-11-14 04:31:41','2026-11-14 04:31:42');
/*!40000 ALTER TABLE `leads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_reports`
--

DROP TABLE IF EXISTS `marketing_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_type` enum('DAILY','WEEKLY','MONTHLY') COLLATE utf8mb4_unicode_ci NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `summary_text` mediumtext COLLATE utf8mb4_unicode_ci,
  `recommendations_text` mediumtext COLLATE utf8mb4_unicode_ci,
  `metrics_json` mediumtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_reports`
--

LOCK TABLES `marketing_reports` WRITE;
/*!40000 ALTER TABLE `marketing_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_assets`
--

DROP TABLE IF EXISTS `media_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `calendar_id` int(11) DEFAULT NULL,
  `template_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `headline` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtext` text COLLATE utf8mb4_unicode_ci,
  `format` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '1080x1350',
  `local_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `public_url` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `calendar_id` (`calendar_id`),
  CONSTRAINT `media_assets_ibfk_1` FOREIGN KEY (`calendar_id`) REFERENCES `content_calendar` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_assets`
--

LOCK TABLES `media_assets` WRITE;
/*!40000 ALTER TABLE `media_assets` DISABLE KEYS */;
INSERT INTO `media_assets` VALUES (1,1,'tip','Stop Automating Machines. Start Automating Workflows.','The 2026 Playbook for Indian Textile Leaders','1080x1080','render_service\\output\\tip_77d0e86b.png','http://localhost:5001/images/tip_77d0e86b.png','2026-11-14 04:16:30'),(2,NULL,'product-feature','AI ERP','ZetHub','1080x1080','render_service\\output\\product-feature_b989b8dc.png','http://localhost:5001/images/product-feature_b989b8dc.png','2026-11-14 04:31:41');
/*!40000 ALTER TABLE `media_assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platforms`
--

DROP TABLE IF EXISTS `platforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `platforms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `api_status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'DISCONNECTED',
  `config_json` text COLLATE utf8mb4_unicode_ci,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platforms`
--

LOCK TABLES `platforms` WRITE;
/*!40000 ALTER TABLE `platforms` DISABLE KEYS */;
INSERT INTO `platforms` VALUES (1,'Instagram',1,'READY_FOR_AUTH','{\"api_version\": \"v21.0\", \"rate_limit_per_day\": 25}','2026-11-14 03:56:02'),(2,'LinkedIn',1,'READY_FOR_AUTH','{\"api_version\": \"202401\", \"rate_limit_per_day\": 50}','2026-11-14 03:56:02'),(3,'Website CMS / GitHub',1,'CONNECTED','{\"repo\": \"zethub/website\", \"branch\": \"main\", \"blog_dir\": \"content/blog\"}','2026-11-14 03:56:02'),(4,'Email / Brevo',1,'CONFIGURED','{\"provider\": \"brevo\", \"daily_free_limit\": 300}','2026-11-14 03:56:02'),(5,'Telegram Alerts',1,'CONNECTED','{\"bot_name\": \"ZetHubMarketingBot\"}','2026-11-14 03:56:02');
/*!40000 ALTER TABLE `platforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publishing_logs`
--

DROP TABLE IF EXISTS `publishing_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publishing_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `calendar_id` int(11) DEFAULT NULL,
  `platform` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `platform_post_id` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `post_url` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_payload` mediumtext COLLATE utf8mb4_unicode_ci,
  `response_payload` mediumtext COLLATE utf8mb4_unicode_ci,
  `status` enum('SUCCESS','FAILED') COLLATE utf8mb4_unicode_ci NOT NULL,
  `error_message` text COLLATE utf8mb4_unicode_ci,
  `published_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `calendar_id` (`calendar_id`),
  KEY `idx_pub_platform` (`platform`,`published_at`),
  CONSTRAINT `publishing_logs_ibfk_1` FOREIGN KEY (`calendar_id`) REFERENCES `content_calendar` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publishing_logs`
--

LOCK TABLES `publishing_logs` WRITE;
/*!40000 ALTER TABLE `publishing_logs` DISABLE KEYS */;
INSERT INTO `publishing_logs` VALUES (1,NULL,'LinkedIn','linkedin_pub_a8a515eb9c','https://www.linkedin.com/zethub/posts/linkedin_pub_a8a515eb9c','{\"topic\": \"Fast Unit Test Topic\", \"caption\": \"Practical guide on AI ERP integration for Indian SMEs.\"}','{\"status\": \"published\", \"id\": \"linkedin_pub_a8a515eb9c\", \"url\": \"https://www.linkedin.com/zethub/posts/linkedin_pub_a8a515eb9c\"}','SUCCESS',NULL,'2026-11-14 04:31:41'),(2,1,'LinkedIn','linkedin_pub_71621745ed','https://www.linkedin.com/zethub/posts/linkedin_pub_71621745ed','{\"topic\": \"Why Indian textile manufacturers are adopting AI workflow automation in 2026\", \"caption\": \"Most Indian textile manufacturers still treat automation as a cost center. They buy a machine, install it, and walk away.\\n\\nBut here is the harsh reality: The bottleneck isn\'t the machinery. It\\u2019s the data gap.\\n\\nIn a typical mill, 40% of time is lost to manual data entry, delayed quality checks, and reactive maintenance. When you scale, these inefficiencies compound exponentially.\\n\\nIn 2026, the winning strategy isn\'t just \'smart machines.\' It\\u2019s intelligent workflows.\\n\\nHere\\u2019s what AI workflow automation actually fixes:\\n\\n\\u2022 Predictive Maintenance: AI analyzes spindle vibration and temperature to predict failures before they stop production. No more unscheduled downtime.\\n\\n\\u2022 Real-Time Quality Control: Computer vision models flag fabric defects in milliseconds, not hours. This reduces waste by up to 15%.\\n\\n\\u2022 Supply Chain Sync: AI links raw material inventory with production schedules, ensuring you never over-order or run dry.\\n\\n\\u2022 Automated Reporting: No more end-of-day manual reports. Data flows directly from the floor to the boardroom dashboard.\\n\\nThe ROI? \\n\\nA mid-sized mill we recently worked with reduced downtime by 22% and cut quality rejection rates by 18% within 6 months. The system paid for itself in 4 months.\\n\\nThis isn\'t science fiction. It\\u2019s operational survival.\\n\\nIf you are still relying on Excel sheets and manual logs to run a multi-million rupee operation, you are competing with a handicap.\\n\\nThe future of Indian textiles belongs to those who automate the workflow, not just the machine.\"}','{\"status\": \"published\", \"id\": \"linkedin_pub_71621745ed\", \"url\": \"https://www.linkedin.com/zethub/posts/linkedin_pub_71621745ed\"}','SUCCESS',NULL,'2026-11-14 05:28:45');
/*!40000 ALTER TABLE `publishing_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publishing_queue`
--

DROP TABLE IF EXISTS `publishing_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publishing_queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `calendar_id` int(11) NOT NULL,
  `platform` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scheduled_time` datetime NOT NULL,
  `retry_count` int(11) DEFAULT '0',
  `last_error` text COLLATE utf8mb4_unicode_ci,
  `status` enum('QUEUED','PROCESSING','COMPLETED','FAILED') COLLATE utf8mb4_unicode_ci DEFAULT 'QUEUED',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `calendar_id` (`calendar_id`),
  KEY `idx_queue_scheduled` (`scheduled_time`,`status`),
  CONSTRAINT `publishing_queue_ibfk_1` FOREIGN KEY (`calendar_id`) REFERENCES `content_calendar` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publishing_queue`
--

LOCK TABLES `publishing_queue` WRITE;
/*!40000 ALTER TABLE `publishing_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `publishing_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permissions` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seo_audits`
--

DROP TABLE IF EXISTS `seo_audits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seo_audits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description` text COLLATE utf8mb4_unicode_ci,
  `h1_tags` text COLLATE utf8mb4_unicode_ci,
  `broken_links` text COLLATE utf8mb4_unicode_ci,
  `performance_score` int(11) DEFAULT '0',
  `audit_report_json` mediumtext COLLATE utf8mb4_unicode_ci,
  `audited_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seo_audits`
--

LOCK TABLES `seo_audits` WRITE;
/*!40000 ALTER TABLE `seo_audits` DISABLE KEYS */;
/*!40000 ALTER TABLE `seo_audits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seo_keywords`
--

DROP TABLE IF EXISTS `seo_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seo_keywords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyword` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `search_intent` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'Informational',
  `monthly_volume` int(11) DEFAULT '0',
  `difficulty` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Medium',
  `priority` enum('LOW','MEDIUM','HIGH') COLLATE utf8mb4_unicode_ci DEFAULT 'MEDIUM',
  `target_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('DISCOVERED','PLANNED','DRAFTED','PUBLISHED') COLLATE utf8mb4_unicode_ci DEFAULT 'DISCOVERED',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `keyword` (`keyword`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seo_keywords`
--

LOCK TABLES `seo_keywords` WRITE;
/*!40000 ALTER TABLE `seo_keywords` DISABLE KEYS */;
INSERT INTO `seo_keywords` VALUES (1,'AI automation for Indian SMEs','Commercial',1200,'Low','HIGH',NULL,'PLANNED','2026-11-14 03:56:32'),(2,'SaaS development company Madurai','Commercial',800,'Low','HIGH',NULL,'DISCOVERED','2026-11-14 03:56:32'),(3,'Custom ERP software for textile industry','Commercial',1500,'Medium','HIGH',NULL,'PLANNED','2026-11-14 03:56:32'),(4,'How to automate business workflows using AI','Informational',4500,'Medium','HIGH',NULL,'DISCOVERED','2026-11-14 03:56:32'),(5,'Cost of custom software development in India','Commercial',3200,'Medium','MEDIUM',NULL,'DISCOVERED','2026-11-14 03:56:32'),(6,'n8n enterprise automation consulting','Commercial',950,'Low','MEDIUM',NULL,'DISCOVERED','2026-11-14 03:56:32'),(7,'test automation keyword','Commercial',0,'Medium','HIGH',NULL,'DISCOVERED','2026-11-14 04:31:42');
/*!40000 ALTER TABLE `seo_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'COMPANY_NAME','ZetHub','Brand company name','2026-11-14 03:56:02'),(2,'COMPANY_TAGLINE','AI SaaS & IT Solutions for Modern Enterprises','Company tagline','2026-11-14 03:56:02'),(3,'COMPANY_LOCATION','Madurai, Tamil Nadu, India','Headquarters location','2026-11-14 03:56:02'),(4,'COMPANY_WEBSITE','https://zethub.in','Official website URL','2026-11-14 03:56:02'),(5,'TARGET_AUDIENCE','Indian SMEs, Startups, Founders, Textile & Manufacturing businesses seeking AI automation and software solutions','Target buyer personas','2026-11-14 03:56:02'),(6,'BRAND_VOICE','Authoritative, innovative, practical, value-driven, professional, accessible','Brand tone of voice','2026-11-14 03:56:02'),(7,'AUTO_PUBLISH','FALSE','Global auto-publish toggle (TRUE=publish, FALSE=draft/pause)','2026-11-14 03:56:02'),(8,'OPERATING_MODE','APPROVAL','Current operating mode: MANUAL, APPROVAL, FULL_AUTOMATION','2026-11-14 03:56:02'),(9,'INSTAGRAM_POSTING_TIMES','10:30,18:30','Configured daily posting times in IST','2026-11-14 03:56:02'),(10,'LINKEDIN_POSTING_TIMES','09:00,16:30','Configured daily posting times in IST','2026-11-14 03:56:02'),(11,'EMERGENCY_KILL_SWITCH','FALSE','Global emergency stop (TRUE halts all publishing immediately)','2026-11-14 03:56:02'),(12,'DAILY_POST_LIMIT','2','Max social posts per platform per day','2026-11-14 03:56:02'),(13,'QA_BANNED_WORDS','guaranteed profits,crypto scam,get rich quick,100% free money,miracle solution','Comma-separated banned words','2026-11-14 03:56:02'),(27,'TEST_SETTING','ALPHA',NULL,'2026-11-14 04:31:41');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_accounts`
--

DROP TABLE IF EXISTS `social_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform_id` int(11) DEFAULT NULL,
  `account_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `access_token` text COLLATE utf8mb4_unicode_ci,
  `refresh_token` text COLLATE utf8mb4_unicode_ci,
  `token_expires_at` timestamp NULL DEFAULT NULL,
  `is_connected` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `platform_id` (`platform_id`),
  CONSTRAINT `social_accounts_ibfk_1` FOREIGN KEY (`platform_id`) REFERENCES `platforms` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_accounts`
--

LOCK TABLES `social_accounts` WRITE;
/*!40000 ALTER TABLE `social_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_logs`
--

DROP TABLE IF EXISTS `system_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` enum('INFO','WARN','ERROR','CRITICAL') COLLATE utf8mb4_unicode_ci DEFAULT 'INFO',
  `source` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `context_json` mediumtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_log_level` (`level`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_logs`
--

LOCK TABLES `system_logs` WRITE;
/*!40000 ALTER TABLE `system_logs` DISABLE KEYS */;
INSERT INTO `system_logs` VALUES (1,'INFO','SettingsAPI','Updated setting TEST_SETTING to ALPHA','{\"key\": \"TEST_SETTING\"}','2026-11-14 04:31:41'),(2,'INFO','ContentFactory','Generated content ZH-57B580E2 for LinkedIn','{\"topic\": \"Fast Unit Test Topic\", \"qa\": \"PASSED\"}','2026-11-14 04:31:41'),(3,'INFO','ApprovalEngine','Content ID 2 marked as APPROVED',NULL,'2026-11-14 04:31:41'),(4,'INFO','LeadIntake','New lead captured: API Test Prospect (HOT)','{\"score\": 90, \"company\": \"Test Garments Ltd\"}','2026-11-14 04:31:41'),(5,'INFO','LeadIntake','New lead captured: Security Tester (COLD)','{\"score\": 8, \"company\": \"Secure Inc\"}','2026-11-14 04:31:52');
/*!40000 ALTER TABLE `system_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'admin',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'zethub_marketing_os'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-14 11:15:34
