# Official API Integrations Guide

## 1. Vireonix AI API (Central Intelligence)
- **Endpoint**: `https://vireonix.ai/v1/chat/completions`
- **Method**: `POST`
- **Model**: `auto`
- **Authentication**: None currently required (open endpoint).
- **Request Format**: OpenAI-compatible JSON payload:
  ```json
  {
    "model": "auto",
    "messages": [
      {"role": "system", "content": "System prompt..."},
      {"role": "user", "content": "User prompt..."}
    ]
  }
  ```
- **Response Format**: `choices[0].message.content`

---

## 2. Meta Instagram Graph API (Official)
- **Requirements**:
  1. Professional Instagram Business / Creator account.
  2. Linked to a Facebook Page.
  3. Meta Developer App with `instagram_basic`, `instagram_content_publish`, and `pages_read_engagement`.
- **Publishing Steps**:
  1. **Upload Container**:
     `POST https://graph.facebook.com/v21.0/{ig-user-id}/media`
     Parameters: `image_url={public_url}`, `caption={caption_text}`, `access_token={token}`
     Returns: `{ "id": "{creation_id}" }`
  2. **Publish Container**:
     `POST https://graph.facebook.com/v21.0/{ig-user-id}/media_publish`
     Parameters: `creation_id={creation_id}`, `access_token={token}`
     Returns: `{ "id": "{published_media_id}" }`

---

## 3. LinkedIn API (Official Community Management)
- **Requirements**:
  1. LinkedIn Developer Application.
  2. ZetHub LinkedIn Company Page administrator privileges.
  3. Product permission: "Share on LinkedIn" or "Sign In with LinkedIn".
- **Publishing Step**:
  `POST https://api.linkedin.com/v2/ugcPosts`
  Header: `Authorization: Bearer {token}`

---

## 4. Brevo API (Transactional & Newsletter Email)
- **Free Tier Quota**: 300 emails / day.
- **Endpoint**: `POST https://api.brevo.com/v3/smtp/email`
- **Header**: `api-key: {BREVO_API_KEY}`
- **Compliance Rules**:
  - Send only to recipients where `consent = TRUE`.
  - Include working `{{unsubscribe_url}}` footer.

---

## 5. IndexNow Protocol (Instant Search Indexing)
- **Endpoint**: `POST https://api.indexnow.org/indexnow`
- **Payload**:
  ```json
  {
    "host": "zethub.in",
    "key": "your-indexnow-key",
    "urlList": ["https://zethub.in/blog/your-slug"]
  }
  ```

