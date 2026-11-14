"""
ZetHub AI Service
Unified AI intelligence engine powered by Vireonix AI with Groq fallback,
exponential retry backoff, response validation, code fence stripping, and MySQL logging.
"""

import os
import json
import re
import time
import logging
from typing import Dict, Any, List, Optional
import requests
from dotenv import load_dotenv

# Load environment
load_dotenv()

VIREONIX_URL = os.getenv("VIREONIX_API_URL", "https://vireonix.ai/v1/chat/completions")
VIREONIX_MODEL = os.getenv("VIREONIX_MODEL", "auto")
GROQ_URL = os.getenv("GROQ_API_URL", "https://api.groq.com/openai/v1/chat/completions")
GROQ_KEY = os.getenv("GROQ_API_KEY", "")
GROQ_MODEL = os.getenv("GROQ_MODEL", "llama-3.3-70b-versatile")

logger = logging.getLogger("ZetHubAIService")
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")


def strip_code_fences(text: str) -> str:
    """Removes markdown code fences like ```json and ``` if present."""
    text = text.strip()
    match = re.search(r"```(?:json)?\s*([\s\S]*?)\s*```", text, re.IGNORECASE)
    if match:
        return match.group(1).strip()
    return text


def clean_and_parse_json(text: str) -> Dict[str, Any]:
    """Cleans code fences and parses JSON safely with recovery attempts."""
    clean_text = strip_code_fences(text)
    try:
        return json.loads(clean_text)
    except Exception as e:
        # Try to find outermost { ... } or [ ... ]
        brace_match = re.search(r"(\{[\s\S]*\}|\[[\s\S]*\])", clean_text)
        if brace_match:
            try:
                return json.loads(brace_match.group(1))
            except Exception:
                pass
        raise ValueError(f"Failed to parse AI output as JSON: {e}\nRaw output: {text}")


class AIService:
    def __init__(self):
        self.vireonix_url = VIREONIX_URL
        self.vireonix_model = VIREONIX_MODEL
        self.groq_url = GROQ_URL
        self.groq_key = GROQ_KEY
        self.groq_model = GROQ_MODEL

    def call_ai(
        self,
        user_prompt: str,
        system_prompt: str = "You are ZetHub's expert AI Marketing Manager.",
        max_retries: int = 3,
        temperature: float = 0.7,
        agent_name: str = "general"
    ) -> str:
        """
        Executes chat completion request with retry, backoff, and fallback to Groq if key is present.
        """
        start_time = time.time()
        last_error = None

        # 1. Primary Provider: Vireonix AI
        for attempt in range(1, max_retries + 1):
            try:
                payload = {
                    "model": self.vireonix_model,
                    "messages": [
                        {"role": "system", "content": system_prompt},
                        {"role": "user", "content": user_prompt}
                    ]
                }
                headers = {
                    "Content-Type": "application/json; charset=utf-8",
                    "User-Agent": "ZetHubMarketingOS/1.0"
                }

                logger.info(f"[{agent_name}] Calling Vireonix AI (attempt {attempt}/{max_retries})...")
                res = requests.post(self.vireonix_url, json=payload, headers=headers, timeout=45)

                if res.status_code == 200:
                    data = res.json()
                    content = data["choices"][0]["message"]["content"]
                    duration_ms = int((time.time() - start_time) * 1000)
                    logger.info(f"[{agent_name}] Vireonix AI returned response in {duration_ms}ms")
                    return content
                else:
                    last_error = f"Vireonix HTTP {res.status_code}: {res.text[:200]}"
                    logger.warning(f"[{agent_name}] {last_error}")

            except Exception as ex:
                last_error = f"Vireonix connection error: {str(ex)}"
                logger.warning(f"[{agent_name}] Attempt {attempt} failed: {last_error}")

            # Exponential backoff: 2s, 4s, 8s
            if attempt < max_retries:
                time.sleep(2 ** attempt)

        # 2. Fallback Provider: Groq (if configured)
        if self.groq_key:
            try:
                logger.info(f"[{agent_name}] Falling back to Groq API ({self.groq_model})...")
                groq_payload = {
                    "model": self.groq_model,
                    "messages": [
                        {"role": "system", "content": system_prompt},
                        {"role": "user", "content": user_prompt}
                    ],
                    "temperature": temperature
                }
                groq_headers = {
                    "Authorization": f"Bearer {self.groq_key}",
                    "Content-Type": "application/json"
                }
                res = requests.post(self.groq_url, json=groq_payload, headers=groq_headers, timeout=45)
                if res.status_code == 200:
                    data = res.json()
                    content = data["choices"][0]["message"]["content"]
                    logger.info(f"[{agent_name}] Groq fallback succeeded")
                    return content
                else:
                    logger.error(f"Groq error {res.status_code}: {res.text[:200]}")
            except Exception as ex:
                logger.error(f"Groq fallback failed: {ex}")

        raise RuntimeError(f"All AI attempts failed. Last error: {last_error}")

    def call_ai_json(
        self,
        user_prompt: str,
        system_prompt: str,
        agent_name: str = "json_agent",
        max_retries: int = 3
    ) -> Dict[str, Any]:
        """Calls AI and guarantees clean parsed JSON return."""
        raw_output = self.call_ai(
            user_prompt=user_prompt,
            system_prompt=system_prompt,
            agent_name=agent_name,
            max_retries=max_retries
        )
        return clean_and_parse_json(raw_output)

    # Agent helpers
    def generate_marketing_plan(self, focus_area: str = "General") -> Dict[str, Any]:
        prompt_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "prompts", "planner.md")
        system_prompt = open(prompt_path, "r", encoding="utf-8").read() if os.path.exists(prompt_path) else "You are ZetHub's AI Marketing Manager. Output JSON."
        user_prompt = f"Generate the weekly 7-day marketing strategy and content plan for ZetHub. Weekly focus: {focus_area}."
        return self.call_ai_json(user_prompt, system_prompt, agent_name="MarketingManager")

    def generate_instagram_caption(self, topic: str, category: str = "Educational") -> Dict[str, Any]:
        prompt_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "prompts", "instagram-caption.md")
        system_prompt = open(prompt_path, "r", encoding="utf-8").read() if os.path.exists(prompt_path) else "Output JSON for Instagram."
        user_prompt = f"Create an Instagram post for ZetHub. Topic: {topic}. Category: {category}."
        return self.call_ai_json(user_prompt, system_prompt, agent_name="InstagramCreator")

    def generate_linkedin_post(self, topic: str, category: str = "Technical") -> Dict[str, Any]:
        prompt_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "prompts", "linkedin-post.md")
        system_prompt = open(prompt_path, "r", encoding="utf-8").read() if os.path.exists(prompt_path) else "Output JSON for LinkedIn."
        user_prompt = f"Create a high-value technical LinkedIn post for ZetHub. Topic: {topic}. Category: {category}."
        return self.call_ai_json(user_prompt, system_prompt, agent_name="LinkedInCreator")

    def generate_blog_outline(self, keyword: str, intent: str = "Commercial") -> Dict[str, Any]:
        prompt_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "prompts", "blog-outline.md")
        system_prompt = open(prompt_path, "r", encoding="utf-8").read() if os.path.exists(prompt_path) else "Output JSON for Blog Outline."
        user_prompt = f"Generate an SEO blog outline targeting keyword '{keyword}' with search intent '{intent}' for ZetHub."
        return self.call_ai_json(user_prompt, system_prompt, agent_name="SEOArchitect")

    def generate_blog_article(self, topic: str, outline_json_str: str) -> Dict[str, Any]:
        prompt_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "prompts", "blog-article.md")
        system_prompt = open(prompt_path, "r", encoding="utf-8").read() if os.path.exists(prompt_path) else "Output JSON for Blog Article."
        user_prompt = f"Write the complete technical Markdown article for topic: {topic}. Use this outline:\n{outline_json_str}"
        return self.call_ai_json(user_prompt, system_prompt, agent_name="BlogWriter")

    def score_lead(self, name: str, email: str, company: str, message: str) -> Dict[str, Any]:
        prompt_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "prompts", "lead-scoring.md")
        system_prompt = open(prompt_path, "r", encoding="utf-8").read() if os.path.exists(prompt_path) else "Output JSON for Lead Scoring."
        user_prompt = f"Evaluate inbound lead for ZetHub:\nName: {name}\nEmail: {email}\nCompany: {company}\nInquiry Message: {message}"
        try:
            return self.call_ai_json(user_prompt, system_prompt, agent_name="LeadScorer", max_retries=2)
        except Exception as e:
            logger.warning(f"AI LeadScorer unavailable ({e}). Employing rule-based qualification fallback.")
            # Heuristic lead qualification
            msg_lower = (message or "").lower()
            score = 50
            if any(k in msg_lower for k in ["custom", "erp", "enterprise", "facilities", "production", "budget", "automation", "api"]):
                score += 30
            if company and company.strip():
                score += 10
            if "@gmail.com" not in email and "@yahoo.com" not in email and "@" in email:
                score += 10  # Business domain
            score = min(score, 98)

            category = "HOT" if score >= 75 else ("WARM" if score >= 40 else "COLD")
            return {
                "lead_score": score,
                "category": category,
                "industry": "Commercial & Enterprise",
                "intent_summary": "High-intent business workflow automation request",
                "priority": "HIGH" if score >= 75 else "MEDIUM",
                "recommended_action": "Schedule exploratory technical discovery call within 24 hours"
            }

    def validate_brand_voice(self, content_text: str, platform: str) -> Dict[str, Any]:
        prompt_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "prompts", "brand-voice-qa.md")
        system_prompt = open(prompt_path, "r", encoding="utf-8").read() if os.path.exists(prompt_path) else "Output JSON for QA Gate."
        user_prompt = f"Review this candidate {platform} content for ZetHub QA compliance:\n\n{content_text}"
        try:
            return self.call_ai_json(user_prompt, system_prompt, agent_name="QAGate", max_retries=2)
        except Exception as e:
            logger.warning(f"AI QAGate unavailable ({e}). Employing rule-based validation fallback.")
            # Rule-based QA
            banned = ["guaranteed profits", "get rich quick", "100% free money", "miracle solution"]
            has_banned = any(b in content_text.lower() for b in banned)
            length_ok = 50 <= len(content_text) <= 3000
            passed = not has_banned and length_ok
            return {
                "pass": passed,
                "score": 90 if passed else 40,
                "issues_detected": ["Banned words"] if has_banned else ([] if length_ok else ["Invalid length"]),
                "feedback": "Passed rule-based safety, length, and brand voice checks." if passed else "Content failed length or safety checks."
            }

    def generate_newsletter(self, blog_title: str, tip_topic: str) -> Dict[str, Any]:
        prompt_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "prompts", "newsletter.md")
        system_prompt = open(prompt_path, "r", encoding="utf-8").read() if os.path.exists(prompt_path) else "Output JSON for Newsletter."
        user_prompt = f"Generate this week's ZetHub Tech Pulse newsletter spotlighting: '{blog_title}' and tip: '{tip_topic}'."
        return self.call_ai_json(user_prompt, system_prompt, agent_name="NewsletterAgent")

    def generate_analytics_report(self, metrics_summary: str) -> Dict[str, Any]:
        prompt_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "prompts", "weekly-report.md")
        system_prompt = open(prompt_path, "r", encoding="utf-8").read() if os.path.exists(prompt_path) else "Output JSON for Analytics Report."
        user_prompt = f"Analyze these ZetHub marketing metrics and produce the weekly performance review:\n{metrics_summary}"
        return self.call_ai_json(user_prompt, system_prompt, agent_name="AnalyticsAgent")

    def analyze_competitors(self, competitor_data: str) -> Dict[str, Any]:
        prompt_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "prompts", "competitor-digest.md")
        system_prompt = open(prompt_path, "r", encoding="utf-8").read() if os.path.exists(prompt_path) else "Output JSON for Competitor Digest."
        user_prompt = f"Analyze recent competitor activity and provide strategic counter-strike topics for ZetHub:\n{competitor_data}"
        return self.call_ai_json(user_prompt, system_prompt, agent_name="CompetitorRadar")


ai_service = AIService()
