from rich.console import Console
from rich.panel import Panel
from rich.progress import Progress
import json
import requests
from pathlib import Path
from typing import Dict, Any
import sys
import subprocess
from rich.table import Table
import os
from datetime import datetime

class ConfigManager:
    def __init__(self, config_path: str):
        self.console = Console()
        self.config_path = Path(config_path)
        self.config: Dict[str, Any] = {}
        self.load_config()

    def load_config(self) -> None:
        """Load configuration from local file"""
        try:
            if self.config_path.exists():
                with open(self.config_path, 'r') as f:
                    self.config = json.load(f)
                self.console.print(f"[green]Config loaded from {self.config_path}")
            else:
                self.console.print("[yellow]Config file not found, creating default")
                self.create_default_config()
        except Exception as e:
            self.console.print(f"[red]Error loading config: {str(e)}")
            sys.exit(1)

    def create_default_config(self) -> None:
        """Create a default configuration file"""
        default_config = {
            "name": "Automator",
            "version": "1.0",
            "update_url": "",
            "instruction_files": {},
            "settings": {
                "auto_update": True,
                "verify_checksums": True,
                "instructions_cache_dir": "instructions"
            }
        }
        self.save_config(default_config)

    def save_config(self, config: Dict[str, Any]) -> None:
        """Save configuration to file"""
        try:
            with open(self.config_path, 'w') as f:
                json.dump(config, f, indent=4)
            self.config = config
        except Exception as e:
            self.console.print(f"[red]Error saving config: {str(e)}")

    def update_from_url(self, url: str) -> bool:
        """Update configuration from URL"""
        try:
            with Progress() as progress:
                task = progress.add_task("[cyan]Downloading config...", total=1)
                response = requests.get(url)
                progress.update(task, completed=1)
                
            if response.status_code == 200:
                new_config = response.json()
                self.save_config(new_config)
                self.console.print("[green]Configuration updated successfully")
                return True
            else:
                self.console.print("[red]Failed to download configuration")
                return False
        except Exception as e:
            self.console.print(f"[red]Error updating config: {str(e)}")
            return False

    def ensure_cache_dir(self) -> None:
        """Ensure the instructions cache directory exists"""
        cache_dir = self.config['settings']['instructions_cache_dir']
        os.makedirs(cache_dir, exist_ok=True)

    def fetch_instruction_file(self, category: str) -> Dict[str, Any]:
        """Fetch and cache instruction file for a category"""
        instruction_info = self.config['instruction_files'].get(category)
        if not instruction_info:
            raise ValueError(f"No instruction file configured for {category}")

        local_path = Path(instruction_info['local_path'])
        
        # Ensure directory exists
        os.makedirs(local_path.parent, exist_ok=True)
        
        # Check if we need to update
        needs_update = True
        if local_path.exists() and not instruction_info.get('auto_update', True):
            needs_update = False

        if needs_update:
            try:
                response = requests.get(instruction_info['remote_url'])
                if response.status_code == 200:
                    instructions = response.json()
                    with open(local_path, 'w') as f:
                        json.dump(instructions, f, indent=4)
                    instruction_info['local_version'] = instructions.get('version', '1.0')
                    instruction_info['last_updated'] = datetime.now().isoformat()
                    self.save_config(self.config)
                    return instructions
            except Exception as e:
                self.console.print(f"[red]Error fetching instructions: {str(e)}")
                
        # Fall back to local file if exists
        if local_path.exists():
            with open(local_path, 'r') as f:
                return json.load(f)
        
        raise FileNotFoundError(f"No local or remote instructions found for {category}")

class SoftwareManager:
    def __init__(self, config_manager: ConfigManager):
        self.config_manager = config_manager
        self.console = Console()

    def check_instructions_pulled(self, category: str) -> bool:
        """Check if instructions were ever pulled for a category"""
        instruction_info = self.config_manager.config['instruction_files'].get(category)
        if not instruction_info:
            return False
        local_path = Path(instruction_info['local_path'])
        return local_path.exists()

    def list_available_software(self) -> None:
        """Display available instruction sets"""
        table = Table(title="Available Installation Instructions")
        table.add_column("Category", style="cyan")
        table.add_column("Version", style="green")
        table.add_column("Last Updated", style="blue")
        table.add_column("Status", style="yellow")
        
        for category, details in self.config_manager.config['instruction_files'].items():
            status = "Ready" if self.check_instructions_pulled(category) else "Not pulled"
            table.add_row(
                details['name'],
                details.get('local_version', 'Not downloaded'),
                details.get('last_updated', 'Never'),
                status
            )
        
        self.console.print(table)

    def display_packages(self, packages: list) -> None:
        """Display available packages in a table"""
        table = Table(title="Available Packages")
        table.add_column("№", style="cyan", justify="right")
        table.add_column("Name", style="green")
        table.add_column("Type", style="blue")
        table.add_column("Description", style="yellow")
        
        for idx, package in enumerate(packages, 1):
            table.add_row(
                str(idx),
                package['name'],
                package['type'],
                package['description']
            )
        
        self.console.print(table)

    def select_packages(self, packages: list) -> list:
        """Let user select packages to install"""
        self.display_packages(packages)
        
        self.console.print("\n[cyan]Select packages to install:")
        self.console.print("Enter package numbers (comma-separated) or 'all' for all packages")
        self.console.print("Example: 1,3,5 or all")
        
        while True:
            choice = self.console.input("[yellow]Select packages: ").strip().lower()
            
            if choice == 'all':
                return packages
            
            try:
                indices = [int(x.strip()) - 1 for x in choice.split(',')]
                selected = [packages[i] for i in indices if 0 <= i < len(packages)]
                if selected:
                    return selected
                self.console.print("[red]No valid packages selected")
            except (ValueError, IndexError):
                self.console.print("[red]Invalid input. Please try again")

    def install_category(self, category: str) -> bool:
        """Install software from category using fetched instructions"""
        try:
            if not self.check_instructions_pulled(category):
                self.console.print(f"[yellow]Instructions for {category} have never been pulled.")
                if not self.console.input("Would you like to pull them now? [y/N]: ").lower().startswith('y'):
                    self.console.print("[yellow]Installation cancelled.")
                    return False
            
            instructions = self.config_manager.fetch_instruction_file(category)
            packages = instructions.get('packages', [])
            
            if not packages:
                self.console.print("[yellow]No packages found in this category")
                return False

            # Get unique package types
            types = sorted(set(pkg['type'] for pkg in packages))
            
            self.console.print("\n[cyan]Available package types:")
            for idx, type_name in enumerate(types, 1):
                self.console.print(f"{idx}. {type_name}")
            self.console.print(f"{len(types) + 1}. All types")
            
            try:
                type_choice = int(self.console.input("\n[yellow]Choose type (number): "))
                if 1 <= type_choice <= len(types):
                    filtered_packages = [p for p in packages if p['type'] == types[type_choice - 1]]
                elif type_choice == len(types) + 1:
                    filtered_packages = packages
                else:
                    self.console.print("[red]Invalid type selection")
                    return False
            except ValueError:
                self.console.print("[red]Invalid input")
                return False

            selected_packages = self.select_packages(filtered_packages)
            
            with Progress() as progress:
                task = progress.add_task("Installing...", total=len(selected_packages))
                for package in selected_packages:
                    try:
                        result = subprocess.run(
                            package['install_command'],
                            shell=True,
                            capture_output=True,
                            text=True
                        )
                        if result.returncode == 0:
                            self.console.print(f"[green]Installed {package['name']}")
                        else:
                            self.console.print(f"[red]Failed to install {package['name']}")
                    except Exception as e:
                        self.console.print(f"[red]Error installing {package['name']}: {str(e)}")
                    progress.advance(task)

            return True
            
        except Exception as e:
            self.console.print(f"[red]Error installing category {category}: {str(e)}")
            return False

class Automator:
    def __init__(self):
        self.console = Console()
        self.config_manager = ConfigManager('config.json')
        self.software_manager = SoftwareManager(self.config_manager)

    def show_menu(self) -> str:
        """Show interactive menu and return user choice"""
        self.console.print("\n[cyan]Available actions:")
        self.console.print("1. List available software")
        self.console.print("2. Install software category")
        self.console.print("3. Update configuration")
        self.console.print("q. Quit")
        return self.console.input("\n[yellow]Choose an option: ").lower()

    def run(self):
        self.console.print(Panel.fit("Automator Tool", title="Welcome"))
        
        while True:
            choice = self.show_menu()
            
            if choice == 'q':
                break
            elif choice == '1':
                self.software_manager.list_available_software()
            elif choice == '2':
                categories = list(self.config_manager.config['instruction_files'].keys())
                if not categories:
                    self.console.print("[red]No categories available")
                    continue
                
                self.console.print("\n[cyan]Available categories:")
                for i, category in enumerate(categories, 1):
                    self.console.print(f"{i}. {self.config_manager.config['instruction_files'][category]['name']}")
                
                try:
                    idx = int(self.console.input("\n[yellow]Choose category number: ")) - 1
                    if 0 <= idx < len(categories):
                        self.software_manager.install_category(categories[idx])
                    else:
                        self.console.print("[red]Invalid category number")
                except ValueError:
                    self.console.print("[red]Please enter a valid number")
            elif choice == '3':
                if self.config_manager.config.get('update_url'):
                    if not self.config_manager.update_from_url(self.config_manager.config['update_url']):
                        self.console.print("[red]Failed to update configuration. Using local configuration.")
                else:
                    self.console.print("[yellow]No update URL configured")
            else:
                self.console.print("[red]Invalid option")

if __name__ == "__main__":
    try:
        automator = Automator()
        automator.run()
    except KeyboardInterrupt:
        print("\nExiting...")
    except Exception as e:
        Console().print(f"[red]Error: {str(e)}")
