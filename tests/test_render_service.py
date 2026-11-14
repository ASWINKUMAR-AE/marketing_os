"""
Phase 8: Media & Image Render Service Tests
Verifies dimensions, template rendering, and file integrity.
"""

import os
from PIL import Image
from render_service.templates import render_graphic


def test_render_quote_template_1080x1350(tmp_path):
    out_file = str(tmp_path / "test_quote.png")
    res_path = render_graphic(
        template_name="quote",
        headline="AI should eliminate repetitive operations, not create technical debt.",
        subtext="ZetHub Core Engineering",
        format_size="1080x1350",
        output_path=out_file
    )
    assert os.path.exists(res_path)
    with Image.open(res_path) as im:
        assert im.size == (1080, 1350)
        assert im.format == "PNG"


def test_render_product_feature_1080x1080(tmp_path):
    out_file = str(tmp_path / "test_feature.png")
    res_path = render_graphic(
        template_name="product-feature",
        headline="Sub-second Enterprise Workflow Sync",
        subtext="Custom microservices tailored for Indian manufacturing plants.",
        format_size="1080x1080",
        output_path=out_file
    )
    assert os.path.exists(res_path)
    with Image.open(res_path) as im:
        assert im.size == (1080, 1080)
        assert im.format == "PNG"


def test_render_tip_template(tmp_path):
    out_file = str(tmp_path / "test_tip.png")
    res_path = render_graphic(
        template_name="tip",
        headline="How to streamline loom data in 3 steps",
        subtext="1. Automated counters\n2. SQL aggregation\n3. Daily dashboard",
        format_size="1080x1350",
        output_path=out_file
    )
    assert os.path.exists(res_path)


def test_render_announcement_template(tmp_path):
    out_file = str(tmp_path / "test_announcement.png")
    res_path = render_graphic(
        template_name="announcement",
        headline="ZetHub Launches Sovereign AI Suite",
        subtext="Built for local reliability and maximum security.",
        format_size="1080x1350",
        output_path=out_file
    )
    assert os.path.exists(res_path)

