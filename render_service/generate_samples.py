"""
Script to generate 4 distinct sample brand graphics for review.
"""

import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from render_service.templates import render_graphic

out_dir = os.path.join(os.path.dirname(__file__), "output")
os.makedirs(out_dir, exist_ok=True)

# 1. Quote
f1 = os.path.join(out_dir, "sample_quote.png")
render_graphic(
    template_name="quote",
    headline="Real AI automation is not about replacing teams. It is about removing 80% of repetitive operational drag.",
    subtext="ZetHub Engineering Philosophy • Madurai, India",
    format_size="1080x1350",
    output_path=f1
)
print("1. Rendered Quote:", f1)

# 2. Tip
f2 = os.path.join(out_dir, "sample_tip.png")
render_graphic(
    template_name="tip",
    headline="Cut 15 Hours Weekly on Textile Inventory Reporting",
    subtext="1. Connect ERP exports to automated SQL sync.\n2. Replace manual WhatsApp stock checks with a single dashboard.\n3. Automate low-stock alerts before production stalls.",
    format_size="1080x1350",
    output_path=f2
)
print("2. Rendered Tip:", f2)

# 3. Product Feature
f3 = os.path.join(out_dir, "sample_product_feature.png")
render_graphic(
    template_name="product-feature",
    headline="ZetHub Custom AI Pipeline Engine",
    subtext="High-throughput microservice architecture built for Indian manufacturing enterprises. Sub-second data transformation with zero cloud lock-in.",
    format_size="1080x1080",
    output_path=f3
)
print("3. Rendered Product Feature:", f3)

# 4. Announcement
f4 = os.path.join(out_dir, "sample_announcement.png")
render_graphic(
    template_name="announcement",
    headline="Introducing ZetHub Digital Marketing OS v1.0",
    subtext="Autonomous, self-hosted marketing intelligence and publishing suite built for local reliability and sovereign privacy.",
    format_size="1080x1350",
    output_path=f4
)
print("4. Rendered Announcement:", f4)

