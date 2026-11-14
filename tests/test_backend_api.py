"""
Phase 5: Backend API Endpoint Comprehensive Tests
Verifies HTTP status codes, request/response structures, and database persistence.
"""

import pytest
from fastapi.testclient import TestClient
from backend.app.main import app

client = TestClient(app)


def test_api_health():
    res = client.get("/api/health")
    assert res.status_code == 200
    data = res.json()
    assert data["status"] == "healthy"
    assert "company" in data


def test_api_settings_get_and_post():
    # Update a test setting
    res_post = client.post("/api/settings", json={"setting_key": "TEST_SETTING", "setting_value": "ALPHA"})
    assert res_post.status_code == 200

    # Get settings
    res_get = client.get("/api/settings")
    assert res_get.status_code == 200
    assert res_get.json().get("TEST_SETTING") == "ALPHA"


def test_api_content_crud_and_approve():
    # 1. Fetch content list
    res_list = client.get("/api/content")
    assert res_list.status_code == 200
    assert isinstance(res_list.json(), list)

    # 2. Test generation (with fast mock AI so tests run in milliseconds)
    from unittest.mock import patch
    with patch("backend.app.services.ai_service.ai_service.generate_linkedin_post") as mock_gen, \
         patch("backend.app.services.ai_service.ai_service.validate_brand_voice") as mock_qa:

        mock_gen.return_value = {
            "hook": "Scale your manufacturing with AI",
            "content": "Practical guide on AI ERP integration for Indian SMEs.",
            "hashtags": "#ZetHub #AI",
            "image_creative": {"template": "product-feature", "headline": "AI ERP", "subtext": "ZetHub"}
        }
        mock_qa.return_value = {"pass": True, "score": 95, "feedback": "Approved"}

        res_gen = client.post("/api/content/generate", json={
            "topic": "Fast Unit Test Topic",
            "platform": "LinkedIn",
            "category": "Technical"
        })
        assert res_gen.status_code == 200
        gen_data = res_gen.json()
        cal_id = gen_data["calendar_id"]

        # 3. Approve post
        res_app = client.post("/api/content/approve", json={"calendar_id": cal_id, "status": "APPROVED"})
        assert res_app.status_code == 200
        assert res_app.json()["publishing_status"] == "SCHEDULED"

        # 4. Publish Now
        res_pub = client.post("/api/publishing/publish-now", json={"calendar_id": cal_id})
        assert res_pub.status_code == 200
        assert res_pub.json()["publishing_status"] == "PUBLISHED"

        # 5. Delete test post
        res_del = client.delete(f"/api/content/{cal_id}")
        assert res_del.status_code == 200


def test_api_leads_intake_and_status_update():
    from unittest.mock import patch
    with patch("backend.app.services.ai_service.ai_service.score_lead") as mock_score:
        mock_score.return_value = {
            "lead_score": 90,
            "category": "HOT",
            "industry": "Textile",
            "recommended_action": "Call immediately"
        }

        res_lead = client.post("/api/leads/intake", json={
            "full_name": "API Test Prospect",
            "email": "testprospect@example.com",
            "company": "Test Garments Ltd",
            "message": "Interested in AI software for stock management"
        })
        assert res_lead.status_code == 200
        lead_id = res_lead.json()["lead_id"]

        # Update status
        res_stat = client.put(f"/api/leads/{lead_id}/status", json={"status_val": "QUALIFIED"})
        assert res_stat.status_code == 200
        assert res_stat.json()["new_status"] == "QUALIFIED"


def test_api_seo_and_blogs():
    # Add keyword
    res_kw = client.post("/api/seo/keywords", json={"keyword": "test automation keyword", "search_intent": "Commercial", "priority": "HIGH"})
    assert res_kw.status_code == 200

    # Get keywords
    res_get_kw = client.get("/api/seo/keywords")
    assert res_get_kw.status_code == 200

    # Get blogs
    res_blogs = client.get("/api/blogs")
    assert res_blogs.status_code == 200


def test_api_competitors():
    res_add = client.post("/api/competitors", json={"name": "TestCompetitor", "website": "https://test.com", "notes": "Test notes"})
    assert res_add.status_code == 200

    res_get = client.get("/api/competitors")
    assert res_get.status_code == 200
    assert "competitors" in res_get.json()


def test_api_campaigns_and_analytics():
    res_camp = client.get("/api/campaigns")
    assert res_camp.status_code == 200

    res_overview = client.get("/api/analytics/overview")
    assert res_overview.status_code == 200

    res_wf = client.get("/api/workflows")
    assert res_wf.status_code == 200
    assert len(res_wf.json()) == 11

    res_logs = client.get("/api/logs")
    assert res_logs.status_code == 200

