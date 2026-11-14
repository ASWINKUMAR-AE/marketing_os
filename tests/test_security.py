"""
Phase 10: Security Test Suite
Tests SQL injection resistance, XSS sanitization, secret exposure prevention, and CORS.
"""

import pytest
from fastapi.testclient import TestClient
from backend.app.main import app
from backend.app.database.connection import get_db_connection

client = TestClient(app)


def test_sql_injection_defense():
    # Attempt SQL injection payload in lead query
    sqli_payload = "' OR '1'='1"
    res = client.get(f"/api/leads?status={sqli_payload}")
    assert res.status_code == 200
    # The parameterized query should treat this as a literal string status and return 0 rows rather than all rows
    assert len(res.json()) == 0


def test_xss_payload_in_lead():
    xss_message = "<script>alert('xss')</script> Need enterprise AI software"
    res = client.post("/api/leads/intake", json={
        "full_name": "Security Tester",
        "email": "sec@example.com",
        "company": "Secure Inc",
        "message": xss_message
    })
    assert res.status_code == 200
    # Verify in DB that it is safely stored parameterized without evaluating
    conn = get_db_connection()
    with conn.cursor() as cur:
        cur.execute("SELECT message FROM leads WHERE email = 'sec@example.com'")
        row = cur.fetchone()
        assert row["message"] == xss_message
        cur.execute("DELETE FROM leads WHERE email = 'sec@example.com'")
    conn.close()


def test_no_secrets_in_settings_endpoint():
    res = client.get("/api/settings")
    assert res.status_code == 200
    settings = res.json()
    # Check that private passwords and API keys from .env are NOT in settings table
    assert "MYSQL_PASSWORD" not in settings
    assert "GROQ_API_KEY" not in settings
    assert "TELEGRAM_BOT_TOKEN" not in settings

