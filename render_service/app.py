"""
ZetHub Image Render Microservice
Runs on port 5001. Renders high-quality brand graphics from templates.
"""

import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from render_service.templates import render_graphic

app = FastAPI(title="ZetHub Image Render Service", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "output")
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Mount static files so n8n or dashboard can access /images/{filename}
app.mount("/images", StaticFiles(directory=OUTPUT_DIR), name="images")


class RenderRequest(BaseModel):
    template: str = "quote"  # quote, tip, product-feature, announcement
    headline: str
    subtext: str = ""
    format: str = "1080x1350"  # 1080x1350 or 1080x1080


@app.get("/health")
def health():
    return {"status": "ok", "service": "ZetHub Render Service", "port": 5001}


@app.post("/render")
def render_image(req: RenderRequest):
    try:
        import uuid
        filename = f"{req.template}_{uuid.uuid4().hex[:8]}.png"
        filepath = os.path.join(OUTPUT_DIR, filename)

        rendered_path = render_graphic(
            template_name=req.template,
            headline=req.headline,
            subtext=req.subtext,
            format_size=req.format,
            output_path=filepath
        )

        return {
            "status": "success",
            "template": req.template,
            "format": req.format,
            "filename": filename,
            "local_path": rendered_path,
            "image_url": f"http://localhost:5001/images/{filename}"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Image rendering failed: {str(e)}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=5001)

