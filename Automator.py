#!/usr/bin/env python3
import os
import sys
import time
import json
import subprocess
from pathlib import Path
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt
from rich.progress import track
from automator.config import Config

# Optional: if you want YAML support, install PyYAML (pip install PyYAML)
try:
    import yaml
except ImportError:
    yaml = None

# We'll use the requests module to download the official file.
try:
    import requests
except ImportError:
    print("The 'requests' module is required. Install it via 'pip install requests'.")
    sys.exit(1)

console = Console()

def check_root():
    """Ensure the script is running with root privileges."""
    if os.geteuid() != 0:
        console.print("[red]This script must be run as root or with sufficient permissions.[/red]")
        time.sleep(5)
        sys.exit(1)

def display_banner():
    """Display the ASCII art banner using a Rich Panel."""
    banner = (
        "_█████╗_██╗___██╗████████╗_██████╗_███╗___███╗_█████╗_████████╗_██████╗_██████╗\n"
        "██╔══██╗██║___██║╚══██╔══╝██╔═══██╗████╗_████║██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗\n"
        "███████║██║___██║___██║___██║___██║██╔████╔██║███████║___██║___██║___██║██████╔╝\n"
        "██╔══██║██║___██║___██║___██║___██║██║╚██╔╝██║██╔══██║___██║___██║___██║██╔══██╗\n"
        "██║__██║╚██████╔╝___██║___╚██████╔╝██║_╚═╝_██║██║__██║___██║___╚██████╔╝██║__██║\n"
        "╚═╝__╚═╝ ╚═════╝____╚═╝____╚═════╝ ╚═╝_____╚═╝╚═╝__╚═╝___╚═╝____╚═════╝_╚═╝__╚═╝\n"
    )
    panel = Panel(banner, title="Open Testing", subtitle="Dedicated version for Debian 11", style="bold blue")
    console.print(panel)

def run_command(command: str):
    """Execute a shell command and display its output."""
    console.print(f"[yellow]Running:[/yellow] {command}")
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        if result.stdout:
            console.print(result.stdout.strip())
        if result.stderr:
            console.print(result.stderr.strip(), style="red")
    except Exception as e:
        console.print(f"[red]Error executing command:[/red] {e}")

def load_tools(config: Config) -> Dict[str, Any]:
    """Load tools configuration with integrity verification"""
    tool_path = config.get_tool_path("tools")
    
    if not tool_path.exists():
        try:
            content = config.fetch_remote_tool("tools")
            tool_path.write_text(content)
            config.update_registry("tools", content)
        except Exception as e:
            console.print(f"[red]Error downloading configuration: {e}[/red]")
            sys.exit(1)
    
    content = tool_path.read_text()
    if not config.verify_integrity("tools", content):
        console.print("[red]Warning: Tool configuration integrity check failed![/red]")
        if not Prompt.ask("Continue anyway?", default="n").lower() == "y":
            sys.exit(1)
    
    try:
        return json.loads(content)
    except Exception as e:
        console.print(f"[red]Error loading configuration: {e}[/red]")
        sys.exit(1)

def display_system_info():
    """Display some basic system information."""
    console.print("[blue]Uptime:[/blue]")
    run_command("uptime")
    console.print("[blue]Logged in users:[/blue]")
    run_command("who")
    console.print("[blue]Distribution info:[/blue]")
    run_command("cat /etc/issue")

def main():
    check_root()
    display_banner()
    
    try:
        config = Config()
    except FileNotFoundError as e:
        console.print(f"[red]Error: {e}[/red]")
        sys.exit(1)
    
    tools_data = load_tools(config)

    while True:
        console.print("\n[green]Available Tools:[/green]")
        for tool in tools_data.get("tools", []):
            console.print(f"[yellow]{tool['id']}[/yellow]: {tool['description']}")

        choice = Prompt.ask("\nHow do you want to proceed? (enter tool id or 'q' to quit)")
        if choice.lower() == 'q':
            console.print("[blue]Exiting...[/blue]")
            break

        # Find the selected tool by its id
        selected_tool = next((tool for tool in tools_data.get("tools", []) if str(tool["id"]) == choice), None)
        if not selected_tool:
            console.print("[red]Invalid option. Try again.[/red]")
            continue

        commands = selected_tool.get("commands", [])
        if not commands:
            console.print("[red]No commands defined for this tool.[/red]")
            continue

        console.print(f"[green]Executing '{selected_tool['description']}'...[/green]")

        # Execute each command with a progress indicator
        for cmd in track(commands, description="Executing commands..."):
            run_command(cmd)
            time.sleep(0.5)  # Optional delay between commands

        console.print("[blue]Done with this option.[/blue]\n")

if __name__ == "__main__":
    main()
