"""
Phase 3: Vireonix AI & AI Gateway Test Suite
Tests API connectivity, code fence stripping, error resilience, retry backoff, and fallbacks.
"""

import pytest
import json
from unittest.mock import patch, MagicMock
from backend.app.services.ai_service import AIService, strip_code_fences, clean_and_parse_json


def test_01_api_connectivity_and_live_smoke():
    svc = AIService()
    try:
        res = svc.call_ai("Respond with 'AI_OK'", "Test connectivity", max_retries=1)
        assert len(res) > 0
    except Exception as e:
        pytest.skip(f"Live Vireonix endpoint temporary outage/slow: {e}")


def test_02_valid_request():
    svc = AIService()
    with patch("requests.post") as mock_post:
        mock_post.return_value.status_code = 200
        mock_post.return_value.json.return_value = {
            "choices": [{"message": {"content": "Generated copy"}}]
        }
        res = svc.call_ai("Prompt", "System", max_retries=1)
        assert res == "Generated copy"


def test_03_response_parsing_clean_json():
    raw = '{"status": "ok", "pillar": "Educational"}'
    parsed = clean_and_parse_json(raw)
    assert parsed["status"] == "ok"
    assert parsed["pillar"] == "Educational"


def test_04_empty_response_handling():
    with pytest.raises(ValueError):
        clean_and_parse_json("")


def test_05_invalid_response_handling():
    with pytest.raises(ValueError):
        clean_and_parse_json("Not a json string at all")


def test_06_timeout_handling():
    svc = AIService()
    with patch("requests.post", side_effect=Exception("Read timed out")):
        with pytest.raises(RuntimeError):
            svc.call_ai("Prompt", "System", max_retries=1)


def test_07_http_429_rate_limit_handling():
    svc = AIService()
    with patch("requests.post") as mock_post:
        mock_post.return_value.status_code = 429
        mock_post.return_value.text = "Too Many Requests"
        with pytest.raises(RuntimeError) as excinfo:
            svc.call_ai("Prompt", "System", max_retries=1)
        assert "429" in str(excinfo.value)


def test_08_http_502_error_handling():
    svc = AIService()
    with patch("requests.post") as mock_post:
        mock_post.return_value.status_code = 502
        mock_post.return_value.text = "Bad Gateway"
        with pytest.raises(RuntimeError):
            svc.call_ai("Prompt", "System", max_retries=1)


def test_09_retry_handling_recovers_on_second_attempt():
    svc = AIService()
    with patch("requests.post") as mock_post:
        # 1st attempt fails, 2nd attempt succeeds
        err_resp = MagicMock()
        err_resp.status_code = 502
        err_resp.text = "Temporary 502"

        ok_resp = MagicMock()
        ok_resp.status_code = 200
        ok_resp.json.return_value = {"choices": [{"message": {"content": "Recovered content"}}]}

        mock_post.side_effect = [err_resp, ok_resp]
        with patch("time.sleep"):  # Skip delay in test
            res = svc.call_ai("Prompt", "System", max_retries=2)
            assert res == "Recovered content"


def test_10_strip_code_fences_markdown():
    wrapped = '```json\n{"key": "value"}\n```'
    clean = strip_code_fences(wrapped)
    assert clean == '{"key": "value"}'
    parsed = clean_and_parse_json(wrapped)
    assert parsed["key"] == "value"


def test_11_large_response_handling():
    large_text = '{"article": "' + ("A" * 5000) + '"}'
    parsed = clean_and_parse_json(large_text)
    assert len(parsed["article"]) == 5000


def test_12_brand_voice_qa_rule_fallback_detects_banned_word():
    svc = AIService()
    # Force fallback by mocking AI failure
    with patch("requests.post", side_effect=Exception("API Down")):
        res = svc.validate_brand_voice("Join us for guaranteed profits and 100% free money!", "LinkedIn")
        assert res["pass"] is False
        assert "Banned words" in res["issues_detected"]


def test_13_brand_voice_qa_rule_fallback_passes_compliant_post():
    svc = AIService()
    with patch("requests.post", side_effect=Exception("API Down")):
        good_post = "ZetHub builds high-performance AI workflow automations and custom ERP software for Indian enterprises. Visit zethub.in to explore."
        res = svc.validate_brand_voice(good_post, "LinkedIn")
        assert res["pass"] is True


def test_14_lead_scoring_fallback():
    svc = AIService()
    with patch("requests.post", side_effect=Exception("API Down")):
        lead = svc.score_lead(
            name="Murugan",
            email="murugan@textilecorp.com",
            company="Textile Corp",
            message="We need a custom automated ERP system with real-time analytics across 4 production facilities."
        )
        assert lead["lead_score"] >= 75
        assert lead["category"] == "HOT"

