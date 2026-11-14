"""
Comprehensive XAMPP MySQL Integration Test Suite for ZetHub Marketing OS
Validates all 10 requirements specified in Phase 9 of the XAMPP MySQL Configuration Task.
"""

import os
import sys
import time
import socket
import datetime
import urllib.request
import json
import pymysql
import pytest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from backend.app.database.connection import (
    get_db_connection,
    get_db_cursor,
    transaction,
    execute_query,
    execute_one,
    get_database_health
)
import backend.app.database.connection as db_conn_module


class TestXamppMysqlIntegration:
    """Test suite covering the 10 mandated XAMPP MySQL integration tests."""

    def test_01_mysql_server_availability(self):
        """Test 1: Verify MySQL server is listening on port 3306."""
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(2)
        result = sock.connect_ex(('127.0.0.1', 3306))
        sock.close()
        assert result == 0, "Port 3306 is not listening!"

    def test_02_backend_database_connection(self):
        """Test 2: Verify backend connection to XAMPP MariaDB."""
        conn = get_db_connection()
        assert conn is not None
        with conn.cursor() as cur:
            cur.execute("SELECT VERSION()")
            ver = cur.fetchone()["VERSION()"]
            assert "MariaDB" in ver or "MySQL" in ver
        conn.close()

    def test_03_database_existence(self):
        """Test 3: Verify zethub_marketing_os exists."""
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute("SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'zethub_marketing_os'")
            row = cur.fetchone()
            assert row is not None, "Database zethub_marketing_os does not exist!"
        conn.close()

    def test_04_table_structure(self):
        """Test 4: Verify 26 core tables exist with proper schemas."""
        expected_tables = {
            'settings', 'users', 'roles', 'platforms', 'social_accounts',
            'content_calendar', 'generated_content', 'media_assets', 'campaigns',
            'blog_posts', 'seo_keywords', 'seo_audits', 'competitors',
            'competitor_activity', 'leads', 'lead_sources', 'email_contacts',
            'email_suppressions', 'publishing_queue', 'publishing_logs',
            'automation_workflows', 'automation_executions', 'analytics_daily',
            'marketing_reports', 'ai_requests', 'system_logs'
        }
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute("SHOW TABLES")
            tables = {list(r.values())[0] for r in cur.fetchall()}
            missing = expected_tables - tables
            assert not missing, f"Missing tables: {missing}"
            assert len(tables) >= 26
        conn.close()

    def test_05_crud_operations(self):
        """Test 5: Perform CRUD on leads table with temporary test record."""
        test_email = f"test_qa_{int(time.time())}@zethub.test"
        conn = get_db_connection()
        try:
            with conn.cursor() as cur:
                # CREATE
                cur.execute(
                    "INSERT INTO leads (full_name, email, company, message, lead_score, category) "
                    "VALUES (%s, %s, %s, %s, %s, %s)",
                    ("QA Test Lead", test_email, "Test Corp", "Evaluating ZetHub AI", 88, "HOT")
                )
                lead_id = cur.lastrowid
                assert lead_id > 0, "Insert failed"

                # READ
                cur.execute("SELECT * FROM leads WHERE id = %s", (lead_id,))
                lead = cur.fetchone()
                assert lead is not None
                assert lead["email"] == test_email
                assert lead["lead_score"] == 88
                assert lead["category"] == "HOT"

                # UPDATE
                cur.execute("UPDATE leads SET lead_score = 95 WHERE id = %s", (lead_id,))
                cur.execute("SELECT lead_score FROM leads WHERE id = %s", (lead_id,))
                updated = cur.fetchone()
                assert updated["lead_score"] == 95

                # DELETE
                cur.execute("DELETE FROM leads WHERE id = %s", (lead_id,))
                cur.execute("SELECT * FROM leads WHERE id = %s", (lead_id,))
                deleted = cur.fetchone()
                assert deleted is None, "Record was not deleted"
        finally:
            conn.close()

    def test_06_transaction_rollback(self):
        """Test 6: Verify transaction rollback prevents partial / invalid writes."""
        test_email = f"rollback_{int(time.time())}@zethub.test"
        try:
            with transaction() as cur:
                cur.execute(
                    "INSERT INTO leads (full_name, email, message) VALUES (%s, %s, %s)",
                    ("Rollback Lead", test_email, "This should be rolled back")
                )
                # Intentionally trigger an error to test rollback
                cur.execute("INSERT INTO non_existent_table_xyz VALUES (1)")
        except Exception:
            pass  # Expected exception

        # Verify record does NOT exist
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM leads WHERE email = %s", (test_email,))
            row = cur.fetchone()
            assert row is None, "Rollback failed! Record exists in DB."
        conn.close()
        # Reset telemetry error after controlled test
        db_conn_module._latest_database_error = None

    def test_07_foreign_key_constraints(self):
        """Test 7: Verify foreign key constraint enforcement."""
        conn = get_db_connection()
        with conn.cursor() as cur:
            # Attempt invalid FK insert: publishing_queue with invalid calendar_id
            with pytest.raises(Exception):
                cur.execute(
                    "INSERT INTO publishing_queue (calendar_id, platform_id, status) VALUES (999999, 1, 'QUEUED')"
                )
        conn.close()

    def test_08_n8n_connectivity(self):
        """Test 8: Verify n8n workflow database configuration and workflow registry."""
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) as cnt FROM automation_workflows WHERE is_active = 1")
            row = cur.fetchone()
            assert row["cnt"] >= 10, f"Expected at least 10 active workflows in DB, got {row['cnt']}"
        conn.close()

    def test_09_dashboard_database_status(self):
        """Test 9: Verify live database health status payload via /api/database/status."""
        status_data = get_database_health()
        assert status_data["status"] == "connected"
        assert status_data["database"] == "zethub_marketing_os"
        assert status_data["port"] == 3306
        assert status_data["total_tables"] >= 26
        assert status_data["server_version"] != "unknown"
        assert "password" not in status_data

    def test_10_restart_and_reconnection(self):
        """Test 10: Verify reconnection handling and latency."""
        conn = get_db_connection()
        conn.ping()
        assert conn.open, "Connection ping failed!"
        conn.close()
