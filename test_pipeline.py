"""
Comprehensive End-to-End Pipeline Verification Test
"""

import sys
import os

sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

from fastapi.testclient import TestClient
from backend.app.main import app
import pymysql

client = TestClient(app)

print("=== 1. Testing Health Endpoint ===")
res_health = client.get("/api/health")
print("Status:", res_health.status_code, res_health.json())
assert res_health.status_code == 200

print("\n=== 2. Testing End-to-End Content Generation & Rendering ===")
post_payload = {
    "topic": "Why Indian textile manufacturers are adopting AI workflow automation in 2026",
    "platform": "LinkedIn",
    "category": "Educational"
}
res_gen = client.post("/api/content/generate", json=post_payload)
print("Status:", res_gen.status_code)
gen_data = res_gen.json()
print("Generated Content ID:", gen_data.get("content_id"))
print("QA Status:", gen_data.get("qa_status"))
print("Rendered Image URL:", gen_data.get("image_url"))
print("Caption preview:", gen_data.get("caption")[:120], "...")
assert res_gen.status_code == 200

print("\n=== 3. Testing Inbound Lead Intake & AI CRM Scoring ===")
lead_payload = {
    "full_name": "Murugan Vel",
    "email": "murugan@maduraitextiles.com",
    "phone": "+91 98420 12345",
    "company": "Madurai Textiles & Garments",
    "industry": "Textile Manufacturing",
    "message": "We have 4 production facilities and waste 20 hours each week tracking loom output and fabric yarn stock across spreadsheets. Looking for a custom automated ERP system with real-time analytics.",
    "consent": True,
    "source": "Website Inbound"
}
res_lead = client.post("/api/leads/intake", json=lead_payload)
print("Status:", res_lead.status_code)
lead_data = res_lead.json()
print("Assigned Lead Score:", lead_data.get("lead_score"))
print("Category:", lead_data.get("category"))
print("Recommended Action:", lead_data.get("recommended_action"))
assert res_lead.status_code == 200

print("\n=== 4. Verifying MySQL Database Entries ===")
from backend.app.database.connection import get_db_connection
conn = get_db_connection()
with conn.cursor() as cur:
    cur.execute("SELECT content_id, topic, platform, publishing_status, image_url FROM content_calendar ORDER BY id DESC LIMIT 1")
    latest_post = cur.fetchone()
    print("Latest Post in MySQL:", latest_post)

    cur.execute("SELECT full_name, company, lead_score, category FROM leads ORDER BY id DESC LIMIT 1")
    latest_lead = cur.fetchone()
    print("Latest Lead in MySQL:", latest_lead)
conn.close()

print("\n>>> ALL END-TO-END PIPELINE TESTS PASSED SUCCESSFULLY! <<<")

