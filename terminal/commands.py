"""
Terminal Command Handlers for ZetHub Marketing OS
"""

import os
import pymysql
from dotenv import load_dotenv
from terminal.ai_client import ask_vireonix

load_dotenv(os.path.join(os.path.dirname(__file__), "..", ".env"))

DB_HOST = os.getenv("MYSQL_HOST", "localhost")
DB_USER = os.getenv("MYSQL_USER", "root")
DB_PASS = os.getenv("MYSQL_PASSWORD", "")
DB_NAME = os.getenv("MYSQL_DATABASE", "zethub_marketing_os")


def get_db():
    try:
        return pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASS,
            database=DB_NAME,
            charset="utf8mb4",
            cursorclass=pymysql.cursors.DictCursor
        )
    except Exception:
        return None


def cmd_help():
    return """
[bold cyan]Available ZetHub Marketing OS Commands:[/bold cyan]
  [green]/status[/green]      - Check health of Vireonix AI, MySQL, n8n, and active mode
  [green]/content[/green]     - Generate general marketing ideas or content ([italic]e.g. /content 5 ideas for textile SMEs[/italic])
  [green]/instagram[/green]   - Generate an Instagram post with caption, hashtags, and visual brief
  [green]/linkedin[/green]    - Generate an authoritative technical LinkedIn post
  [green]/blog[/green]        - Generate an SEO blog article or outline
  [green]/seo[/green]         - Audit keywords and generate SEO recommendations
  [green]/competitor[/green]  - Generate competitor positioning analysis and counter-topics
  [green]/leads[/green]       - View recent inbound leads or score a prospect
  [green]/email[/green]       - Generate newsletter or lead nurture draft
  [green]/report[/green]      - Generate weekly marketing performance summary
  [green]/workflows[/green]   - List all 10 automation workflows and their execution status
  [green]/publish[/green]     - Review pending drafts and approve content for queue
  [green]/exit[/green]        - Quit terminal assistant
"""


def cmd_status():
    status_lines = []
    # 1. AI check
    try:
        res = ask_vireonix("Respond with 'AI_OK'", "Test")
        ai_status = "[bold green]ONLINE[/bold green]" if "AI_OK" in res or len(res) > 0 else "[yellow]UNEXPECTED[/yellow]"
    except Exception as e:
        ai_status = f"[bold red]OFFLINE ({e})[/bold red]"

    # 2. DB check
    conn = get_db()
    if conn:
        with conn.cursor() as cur:
            cur.execute("SELECT setting_key, setting_value FROM settings WHERE setting_key IN ('AUTO_PUBLISH', 'OPERATING_MODE')")
            rows = {r['setting_key']: r['setting_value'] for r in cur.fetchall()}
            cur.execute("SELECT COUNT(*) AS c FROM content_calendar")
            total_content = cur.fetchone()['c']
            cur.execute("SELECT COUNT(*) AS c FROM leads")
            total_leads = cur.fetchone()['c']
        conn.close()
        db_status = f"[bold green]CONNECTED (MySQL localhost:3306)[/bold green]\n  Mode: {rows.get('OPERATING_MODE', 'APPROVAL')} | Auto-Publish: {rows.get('AUTO_PUBLISH', 'FALSE')}\n  Total Content: {total_content} | Total Leads: {total_leads}"
    else:
        db_status = "[bold red]DISCONNECTED[/bold red]"

    return f"""
[bold cyan]=== ZetHub Marketing OS System Health ===[/bold cyan]
• Vireonix AI API: {ai_status} (model: auto)
• Database: {db_status}
• Render Service: [cyan]http://localhost:5001[/cyan]
• Dashboard: [cyan]http://localhost:5173[/cyan]
• n8n Engine: [cyan]http://localhost:5678[/cyan]
"""


def cmd_workflows():
    conn = get_db()
    if not conn:
        return "[red]Database not connected[/red]"
    with conn.cursor() as cur:
        cur.execute("SELECT workflow_code, name, status, trigger_schedule FROM automation_workflows ORDER BY id")
        rows = cur.fetchall()
    conn.close()

    output = "[bold cyan]=== ZetHub Automation Workflows ===[/bold cyan]\n"
    for r in rows:
        output += f"• [bold yellow]{r['workflow_code']}[/bold yellow] - {r['name']} | [green]{r['status']}[/green] ({r['trigger_schedule']})\n"
    return output


def cmd_leads():
    conn = get_db()
    if not conn:
        return "[red]Database not connected[/red]"
    with conn.cursor() as cur:
        cur.execute("SELECT full_name, email, company, lead_score, category, status FROM leads ORDER BY id DESC LIMIT 5")
        rows = cur.fetchall()
    conn.close()

    if not rows:
        return "[yellow]No leads recorded yet. Submissions from website form will appear here.[/yellow]"

    output = "[bold cyan]=== Recent Inbound Leads ===[/bold cyan]\n"
    for r in rows:
        output += f"• {r['full_name']} ({r['email']}) - [bold]{r['company']}[/bold] | Score: {r['lead_score']} | [{r['category']}] | Status: {r['status']}\n"
    return output

