"""
ZetHub Brand Image Template Engine
Generates high-resolution 1080x1350 and 1080x1080 graphics with professional typography,
glassmorphism card aesthetics, neon accents, and brand styling using Pillow.
"""

import os
from PIL import Image, ImageDraw, ImageFont


def get_font(size: int, bold: bool = False):
    """Attempts to find a clean system sans-serif font (Segoe UI or Arial) or falls back to default."""
    font_names = [
        "C:\\Windows\\Fonts\\segoeuib.ttf" if bold else "C:\\Windows\\Fonts\\segoeui.ttf",
        "C:\\Windows\\Fonts\\arialbd.ttf" if bold else "C:\\Windows\\Fonts\\arial.ttf",
        "C:\\Windows\\Fonts\\calibrib.ttf" if bold else "C:\\Windows\\Fonts\\calibri.ttf"
    ]
    for path in font_names:
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except Exception:
                pass
    return ImageFont.load_default()


def wrap_text(text: str, font, max_width: int, draw: ImageDraw.Draw) -> list:
    """Wraps text so each line fits within max_width pixels."""
    words = text.split()
    lines = []
    current_line = []
    for word in words:
        test_line = " ".join(current_line + [word])
        bbox = draw.textbbox((0, 0), test_line, font=font)
        w = bbox[2] - bbox[0]
        if w <= max_width:
            current_line.append(word)
        else:
            if current_line:
                lines.append(" ".join(current_line))
            current_line = [word]
    if current_line:
        lines.append(" ".join(current_line))
    return lines


def draw_header_footer(draw: ImageDraw.Draw, width: int, height: int, category: str = "AI & SOFTWARE"):
    """Draws uniform ZetHub brand header and footer."""
    # Top brand bar
    font_brand = get_font(36, bold=True)
    font_cat = get_font(24, bold=False)

    draw.text((70, 70), "ZetHub", fill=(0, 242, 254), font=font_brand)
    bbox = draw.textbbox((0, 0), "ZetHub", font=font_brand)
    brand_w = bbox[2] - bbox[0]

    # Category pill on top right
    cat_text = category.upper()
    cat_bbox = draw.textbbox((0, 0), cat_text, font=font_cat)
    cat_w = cat_bbox[2] - cat_bbox[0]
    cat_x = width - 70 - cat_w - 30
    draw.rounded_rectangle([cat_x, 65, width - 70, 115], radius=12, fill=(18, 30, 56), outline=(45, 65, 105), width=2)
    draw.text((cat_x + 15, 75), cat_text, fill=(160, 174, 192), font=font_cat)

    # Bottom footer
    font_foot = get_font(26, bold=False)
    draw.line([(70, height - 120), (width - 70, height - 120)], fill=(30, 45, 75), width=2)
    draw.text((70, height - 90), "zethub.in", fill=(255, 255, 255), font=font_foot)
    draw.text((width - 320, height - 90), "Madurai • AI & IT Solutions", fill=(140, 155, 180), font=font_foot)


def render_quote_template(headline: str, subtext: str, width: int = 1080, height: int = 1350) -> Image.Image:
    """Template 1: Quote / High-Impact Statement"""
    img = Image.new("RGB", (width, height), color=(8, 14, 26))
    draw = ImageDraw.Draw(img)

    draw_header_footer(draw, width, height, category="PERSPECTIVE")

    # Card background
    card_box = [70, 200, width - 70, height - 200]
    draw.rounded_rectangle(card_box, radius=24, fill=(13, 22, 42), outline=(32, 50, 85), width=2)

    # Accent decorative glow line
    draw.line([(120, 200), (320, 200)], fill=(0, 242, 254), width=4)

    # Big quotation mark
    font_quote_mark = get_font(120, bold=True)
    draw.text((120, 240), "“", fill=(0, 242, 254), font=font_quote_mark)

    # Quote text (headline)
    font_headline = get_font(52, bold=True)
    max_text_w = width - 260
    lines = wrap_text(headline, font_headline, max_text_w, draw)

    y = 380
    for line in lines:
        draw.text((130, y), line, fill=(255, 255, 255), font=font_headline)
        y += 75

    # Author / context (subtext)
    if subtext:
        y += 40
        draw.line([(130, y), (200, y)], fill=(121, 40, 202), width=3)
        y += 30
        font_sub = get_font(32, bold=False)
        sub_lines = wrap_text(subtext, font_sub, max_text_w, draw)
        for sline in sub_lines:
            draw.text((130, y), sline, fill=(175, 190, 215), font=font_sub)
            y += 48

    return img


def render_tip_template(headline: str, subtext: str, width: int = 1080, height: int = 1350) -> Image.Image:
    """Template 2: Actionable Pro Tip / Guide"""
    img = Image.new("RGB", (width, height), color=(9, 16, 32))
    draw = ImageDraw.Draw(img)

    draw_header_footer(draw, width, height, category="ACTIONABLE TIP")

    # Badge: PRO TIP
    badge_font = get_font(28, bold=True)
    draw.rounded_rectangle([100, 220, 360, 280], radius=12, fill=(0, 242, 254), outline=None)
    draw.text((130, 235), "⚡ ZETHUB PRO TIP", fill=(8, 14, 26), font=badge_font)

    # Headline
    font_headline = get_font(56, bold=True)
    lines = wrap_text(headline, font_headline, width - 200, draw)
    y = 330
    for line in lines:
        draw.text((100, y), line, fill=(255, 255, 255), font=font_headline)
        y += 78

    # Steps Card
    y += 50
    draw.rounded_rectangle([100, y, width - 100, min(y + 460, height - 200)], radius=20, fill=(17, 28, 54), outline=(40, 65, 110), width=2)

    font_sub = get_font(34, bold=False)
    sub_lines = wrap_text(subtext, font_sub, width - 260, draw)
    card_y = y + 40
    for sline in sub_lines:
        draw.text((140, card_y), sline, fill=(225, 235, 250), font=font_sub)
        card_y += 50

    return img


def render_product_feature_template(headline: str, subtext: str, width: int = 1080, height: int = 1350) -> Image.Image:
    """Template 3: Product & Engineering Showcase"""
    img = Image.new("RGB", (width, height), color=(7, 12, 24))
    draw = ImageDraw.Draw(img)

    draw_header_footer(draw, width, height, category="ENGINEERING")

    # Feature Pill
    draw.rounded_rectangle([100, 200, 420, 260], radius=14, fill=(121, 40, 202), outline=None)
    badge_font = get_font(26, bold=True)
    draw.text((125, 215), "✦ SOLUTION SPOTLIGHT", fill=(255, 255, 255), font=badge_font)

    # Title
    font_headline = get_font(54, bold=True)
    lines = wrap_text(headline, font_headline, width - 200, draw)
    y = 300
    for line in lines:
        draw.text((100, y), line, fill=(255, 255, 255), font=font_headline)
        y += 76

    # Specs Card
    y += 40
    card_h = 420
    draw.rounded_rectangle([100, y, width - 100, y + card_h], radius=22, fill=(14, 24, 48), outline=(0, 242, 254), width=2)

    font_sub = get_font(32, bold=False)
    sub_lines = wrap_text(subtext, font_sub, width - 260, draw)
    text_y = y + 40
    for sline in sub_lines:
        draw.text((140, text_y), sline, fill=(200, 215, 240), font=font_sub)
        text_y += 48

    # Bottom Pill
    pill_font = get_font(26, bold=True)
    draw.rounded_rectangle([140, y + card_h - 90, 480, y + card_h - 35], radius=10, fill=(25, 42, 78))
    draw.text((160, y + card_h - 80), "BUILT FOR PRODUCTION", fill=(0, 242, 254), font=pill_font)

    return img


def render_announcement_template(headline: str, subtext: str, width: int = 1080, height: int = 1350) -> Image.Image:
    """Template 4: Company Announcement & Milestone"""
    img = Image.new("RGB", (width, height), color=(10, 15, 30))
    draw = ImageDraw.Draw(img)

    draw_header_footer(draw, width, height, category="ANNOUNCEMENT")

    # Card
    draw.rounded_rectangle([80, 220, width - 80, height - 220], radius=24, fill=(16, 26, 52), outline=(121, 40, 202), width=3)

    # Accent Top Banner
    draw.rounded_rectangle([130, 270, 390, 325], radius=10, fill=(0, 242, 254))
    font_banner = get_font(26, bold=True)
    draw.text((155, 283), "NEW UPDATE", fill=(8, 14, 26), font=font_banner)

    # Headline
    font_headline = get_font(58, bold=True)
    lines = wrap_text(headline, font_headline, width - 240, draw)
    y = 370
    for line in lines:
        draw.text((130, y), line, fill=(255, 255, 255), font=font_headline)
        y += 80

    # Subtext
    y += 30
    draw.line([(130, y), (260, y)], fill=(0, 242, 254), width=3)
    y += 30
    font_sub = get_font(34, bold=False)
    sub_lines = wrap_text(subtext, font_sub, width - 240, draw)
    for sline in sub_lines:
        draw.text((130, y), sline, fill=(185, 200, 225), font=font_sub)
        y += 50

    return img


def render_graphic(template_name: str, headline: str, subtext: str, format_size: str = "1080x1350", output_path: str = None) -> str:
    """Main rendering dispatcher. Returns output path of generated image."""
    dims = (1080, 1080) if format_size == "1080x1080" else (1080, 1350)
    w, h = dims

    t_name = template_name.lower().replace("_", "-")
    if "tip" in t_name:
        img = render_tip_template(headline, subtext, w, h)
    elif "feature" in t_name or "product" in t_name:
        img = render_product_feature_template(headline, subtext, w, h)
    elif "announce" in t_name:
        img = render_announcement_template(headline, subtext, w, h)
    else:  # quote / default
        img = render_quote_template(headline, subtext, w, h)

    if not output_path:
        out_dir = os.path.join(os.path.dirname(__file__), "output")
        os.makedirs(out_dir, exist_ok=True)
        import uuid
        output_path = os.path.join(out_dir, f"{t_name}_{uuid.uuid4().hex[:8]}.png")

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, "PNG", quality=95)
    return output_path

