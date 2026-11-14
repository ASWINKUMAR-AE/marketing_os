"""
Phase 4: Database Integrity Tests
Tests all 26 tables, foreign keys, transaction rollbacks, and duplicate constraints.
"""

import pytest
import pymysql
from backend.app.database.connection import get_db_connection

TABLES_26 = [
    "users", "roles", "settings", "platforms", "social_accounts",
    "content_calendar", "generated_content", "media_assets", "publishing_queue",
    "publishing_logs", "seo_keywords", "seo_audits", "blog_posts", "leads",
    "lead_sources", "campaigns", "email_contacts", "email_suppressions",
    "competitors", "competitor_activity", "analytics_daily", "marketing_reports",
    "automation_workflows", "automation_executions", "ai_requests", "system_logs"
]


def test_database_connection():
    conn = get_db_connection()
    assert conn is not None
    with conn.cursor() as cur:
        cur.execute("SELECT 1 AS ok")
        row = cur.fetchone()
        assert row["ok"] == 1
    conn.close()


def test_all_26_tables_exist():
    conn = get_db_connection()
    with conn.cursor() as cur:
        cur.execute("SHOW TABLES")
        tables = [list(r.values())[0] for r in cur.fetchall()]
        for t in TABLES_26:
            assert t in tables, f"Missing required table: {t}"
    conn.close()


def test_settings_unique_constraint():
    conn = get_db_connection()
    with conn.cursor() as cur:
        cur.execute("INSERT INTO settings (setting_key, setting_value) VALUES ('TEST_KEY_UNIQ', '1') ON DUPLICATE KEY UPDATE setting_value = '1'")
        # Attempt duplicate insert without ON DUPLICATE KEY
        with pytest.raises(pymysql.err.IntegrityError):
            cur.execute("INSERT INTO settings (setting_key, setting_value) VALUES ('TEST_KEY_UNIQ', '2')")
        # Cleanup
        cur.execute("DELETE FROM settings WHERE setting_key = 'TEST_KEY_UNIQ'")
    conn.close()


def test_transaction_rollback():
    conn = get_db_connection()
    conn.autocommit(False)
    try:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO lead_sources (source_name, source_type) VALUES ('ROLLBACK_TEST_SOURCE', 'WEB')")
        conn.rollback()

        with conn.cursor() as cur:
            cur.execute("SELECT * FROM lead_sources WHERE source_name = 'ROLLBACK_TEST_SOURCE'")
            row = cur.fetchone()
            assert row is None, "Rollback failed: row should not exist"
    finally:
        conn.close()


def test_foreign_key_cascade():
    conn = get_db_connection()
    with conn.cursor() as cur:
        # Create parent content calendar row
        cur.execute("""
            INSERT INTO content_calendar
            (content_id, topic, platform, content_category, caption, approval_status, publishing_status)
            VALUES ('ZH-CASCADE-TEST', 'Testing Cascade', 'LinkedIn', 'Technical', 'Caption', 'DRAFT', 'DRAFTED')
        """)
        parent_id = cur.lastrowid

        # Insert child generated_content row
        cur.execute("""
            INSERT INTO generated_content (calendar_id, platform, topic, category)
            VALUES (%s, 'LinkedIn', 'Testing Cascade', 'Technical')
        """, (parent_id,))

        # Delete parent
        cur.execute("DELETE FROM content_calendar WHERE id = %s", (parent_id,))

        # Verify child is deleted via ON DELETE CASCADE
        cur.execute("SELECT * FROM generated_content WHERE calendar_id = %s", (parent_id,))
        child_row = cur.fetchone()
        assert child_row is None, "Cascade failed: child row still exists"
    conn.close()

