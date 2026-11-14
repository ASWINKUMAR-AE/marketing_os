"""
Terminal AI Client for ZetHub Marketing OS
"""

import os
import sys
import json
import requests
from dotenv import load_dotenv

# Load from project root .env
load_dotenv(os.path.join(os.path.dirname(__file__), "..", ".env"))

VIREONIX_URL = os.getenv("VIREONIX_API_URL", "https://vireonix.ai/v1/chat/completions")
VIREONIX_MODEL = os.getenv("VIREONIX_MODEL", "auto")


def ask_vireonix(user_prompt: str, system_prompt: str = "You are ZetHub's digital marketing AI strategist.") -> str:
    """Sends a completion request to Vireonix AI and returns text response."""
    payload = {
        "model": VIREONIX_MODEL,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt}
        ]
    }
    headers = {
        "Content-Type": "application/json; charset=utf-8",
        "User-Agent": "ZetHubTerminalCLI/1.0"
    }
    response = requests.post(VIREONIX_URL, json=payload, headers=headers, timeout=45)
    response.raise_for_status()
    data = response.json()
    return data["choices"][0]["message"]["content"]

