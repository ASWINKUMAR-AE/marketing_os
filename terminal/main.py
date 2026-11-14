"""
ZetHub Marketing OS - Windows AI Terminal Assistant
"""

import sys
import os

# Add root directory to python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from rich.console import Console
from rich.panel import Panel
from terminal.ai_client import ask_vireonix
from terminal.commands import cmd_help, cmd_status, cmd_workflows, cmd_leads

console = Console()


def main():
    console.print(Panel(
        "[bold cyan]ZetHub Digital Marketing OS[/bold cyan]\n"
        "[dim]AI-Powered Automation Engine for ZetHub (Madurai, India)[/dim]\n"
        "[italic green]Type /help for available commands or /exit to quit.[/italic green]",
        border_style="cyan"
    ))

    while True:
        try:
            line = console.input("\n[bold cyan]ZetHub > [/bold cyan]").strip()
            if not line:
                continue

            parts = line.split(maxsplit=1)
            cmd = parts[0].lower()
            arg = parts[1] if len(parts) > 1 else ""

            if cmd in ["/exit", "exit", "quit", "/quit"]:
                console.print("[yellow]Exiting ZetHub Terminal Assistant. Goodbye![/yellow]")
                break

            elif cmd == "/help":
                console.print(cmd_help())

            elif cmd == "/status":
                console.print(cmd_status())

            elif cmd == "/workflows":
                console.print(cmd_workflows())

            elif cmd == "/leads":
                console.print(cmd_leads())

            elif cmd == "/content":
                prompt = arg or "Generate 5 high-converting marketing content ideas for ZetHub targeting Indian SMEs."
                console.print(f"[dim]Consulting Vireonix AI for content ideas...[/dim]")
                res = ask_vireonix(prompt, "You are ZetHub's expert AI Marketing Content Creator. Return structured suggestions.")
                console.print(Panel(res, title="[green]AI Content Suggestions[/green]", border_style="green"))

            elif cmd == "/instagram":
                prompt = arg or "Create an Instagram post explaining how AI workflow automation cuts inventory errors for textile manufacturing businesses."
                console.print(f"[dim]Generating Instagram post with Vireonix AI...[/dim]")
                res = ask_vireonix(prompt, "You are ZetHub's Instagram specialist. Provide Hook, Caption, Hashtags, and Image Creative text.")
                console.print(Panel(res, title="[magenta]Instagram Post Draft[/magenta]", border_style="magenta"))

            elif cmd == "/linkedin":
                prompt = arg or "Create an authoritative technical LinkedIn post on how ZetHub builds custom ERP and SaaS systems for Indian enterprises."
                console.print(f"[dim]Generating LinkedIn post with Vireonix AI...[/dim]")
                res = ask_vireonix(prompt, "You are ZetHub's LinkedIn specialist. Provide Hook, Body with line breaks, Discussion Question, and Hashtags.")
                console.print(Panel(res, title="[blue]LinkedIn Post Draft[/blue]", border_style="blue"))

            elif cmd == "/blog":
                prompt = arg or "Generate an SEO blog outline for keyword 'AI automation for Indian SMEs' for https://zethub.in."
                console.print(f"[dim]Generating Blog Outline with Vireonix AI...[/dim]")
                res = ask_vireonix(prompt, "You are ZetHub's Lead Technical Blog Architect. Provide Title, Slug, Meta Description, H2/H3 Sections, and FAQ.")
                console.print(Panel(res, title="[cyan]SEO Blog Blueprint[/cyan]", border_style="cyan"))

            elif cmd == "/seo":
                prompt = arg or "Analyze key SEO opportunities and recommended meta tags for ZetHub (https://zethub.in), an AI SaaS startup in Madurai."
                console.print(f"[dim]Analyzing SEO with Vireonix AI...[/dim]")
                res = ask_vireonix(prompt, "You are ZetHub's SEO Specialist. Provide Keyword Clusters, Technical SEO recommendations, and Search Intent.")
                console.print(Panel(res, title="[yellow]SEO Intelligence Audit[/yellow]", border_style="yellow"))

            elif cmd == "/competitor":
                prompt = arg or "Analyze public positioning of Zoho and Freshworks vs ZetHub's regional advantages for Indian manufacturing hubs."
                console.print(f"[dim]Running competitor radar with Vireonix AI...[/dim]")
                res = ask_vireonix(prompt, "You are ZetHub's Competitor Intelligence Agent. Provide Market Observations and 3 Counter-Strike Content Topics.")
                console.print(Panel(res, title="[red]Competitor Radar[/red]", border_style="red"))

            elif cmd == "/email":
                prompt = arg or "Draft this week's ZetHub Tech Pulse newsletter spotlighting AI workflow automations and a 15-minute quick-win tip."
                console.print(f"[dim]Drafting newsletter with Vireonix AI...[/dim]")
                res = ask_vireonix(prompt, "You are ZetHub's Email Newsletter Editor. Provide Subject Line, Preview Text, Feature Story, Quick Tip, and CTA.")
                console.print(Panel(res, title="[green]Email Campaign Draft[/green]", border_style="green"))

            elif cmd == "/report":
                prompt = arg or "Generate a weekly executive summary of ZetHub's marketing pipeline and performance highlights."
                console.print(f"[dim]Generating performance report with Vireonix AI...[/dim]")
                res = ask_vireonix(prompt, "You are ZetHub's Analytics Reporting Agent. Provide Executive Summary, Channel Highlights, and Next Week Priorities.")
                console.print(Panel(res, title="[blue]Executive Marketing Report[/blue]", border_style="blue"))

            elif cmd == "/publish":
                console.print("[cyan]Publishing status: System is currently in [bold]APPROVAL[/bold] mode. Posts must be reviewed via Dashboard before going live.[/cyan]")

            else:
                # Direct AI query
                console.print(f"[dim]Querying ZetHub AI...[/dim]")
                res = ask_vireonix(line, "You are ZetHub's digital marketing AI assistant.")
                console.print(Panel(res, title="[cyan]ZetHub AI[/cyan]", border_style="cyan"))

        except KeyboardInterrupt:
            console.print("\n[yellow]Interrupted. Type /exit to quit.[/yellow]")
        except Exception as e:
            console.print(f"[bold red]Error: {e}[/bold red]")


if __name__ == "__main__":
    main()

