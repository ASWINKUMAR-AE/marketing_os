import urllib.request
import json
import ssl

url = "https://vireonix.ai/v1/chat/completions"
payload = {
    "model": "auto",
    "messages": [
        {"role": "system", "content": "You are ZetHub's digital marketing AI assistant."},
        {"role": "user", "content": "Respond strictly with JSON: {\"status\": \"ok\", \"company\": \"ZetHub\"}"}
    ]
}

req = urllib.request.Request(
    url,
    data=json.dumps(payload).encode("utf-8"),
    headers={
        "Content-Type": "application/json; charset=utf-8",
        "User-Agent": "ZetHubMarketingOS/1.0"
    },
    method="POST"
)

try:
    ctx = ssl.create_default_context()
    with urllib.request.urlopen(req, context=ctx, timeout=30) as response:
        res_body = response.read().decode("utf-8")
        data = json.loads(res_body)
        print("HTTP_STATUS:", response.status)
        print("RAW_RESPONSE:")
        print(data["choices"][0]["message"]["content"])
except Exception as e:
    print("FAILED_REQUEST:", type(e).__name__, str(e))

