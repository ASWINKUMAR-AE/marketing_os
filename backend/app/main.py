"""
ZetHub Marketing OS - Backend API Server
"""

import os
import sys

# Ensure root is in path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.app.api.endpoints import router as api_router

app = FastAPI(
    title="ZetHub Digital Marketing OS API",
    description="Backend microservices for ZetHub autonomous marketing department",
    version="1.0.0"
)

# Enable CORS for frontend dashboard and n8n webhooks
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router, prefix="/api")


@app.get("/")
def root():
    return {
        "system": "ZetHub Digital Marketing OS",
        "company": "ZetHub (Madurai, India)",
        "version": "1.0.0",
        "docs_url": "/docs"
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("backend.app.main:app", host="127.0.0.1", port=8000, reload=False)

