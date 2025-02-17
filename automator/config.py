import os
import json
import hashlib
import yaml
import requests
from pathlib import Path
from typing import Dict, Any

class Config:
    def __init__(self, auto_config: str = ".auto-config"):
        self.auto_config_path = Path(auto_config)
        if not self.auto_config_path.exists():
            raise FileNotFoundError(f"Configuration file {auto_config} not found")
        
        with open(self.auto_config_path) as f:
            self.config = yaml.safe_load(f)
        
        self.base_dir = Path(os.path.expanduser(self.config['config_dir']))
        self.tools_dir = self.base_dir / self.config['tools_dir']
        self.registry_file = self.base_dir / self.config['registry_file']
        self.remote_source = self.config['remote_source']
        self.setup()

    def setup(self) -> None:
        """Create necessary directories and files"""
        self.base_dir.mkdir(exist_ok=True)
        self.tools_dir.mkdir(exist_ok=True)
        if not self.registry_file.exists():
            self.registry_file.write_text("{}")

    def calculate_hash(self, content: str) -> str:
        """Calculate SHA-256 hash of content"""
        return hashlib.sha256(content.encode()).hexdigest()

    def verify_integrity(self, tool_id: str, content: str) -> bool:
        """Verify tool configuration integrity against registry"""
        registry = self.load_registry()
        stored_hash = registry.get(tool_id)
        return stored_hash == self.calculate_hash(content)

    def load_registry(self) -> Dict[str, str]:
        """Load the hash registry"""
        return json.loads(self.registry_file.read_text())

    def update_registry(self, tool_id: str, content: str) -> None:
        """Update hash registry for a tool"""
        registry = self.load_registry()
        registry[tool_id] = self.calculate_hash(content)
        self.registry_file.write_text(json.dumps(registry, indent=2))

    def fetch_remote_tool(self, tool_id: str) -> str:
        """Fetch tool configuration from remote source"""
        response = requests.get(f"{self.remote_source}/tools/{tool_id}.json")
        if response.status_code == 200:
            return response.text
        raise Exception(f"Failed to fetch remote tool: {response.status_code}")

    def get_tool_path(self, tool_id: str) -> Path:
        """Get the local path for a tool configuration"""
        return self.tools_dir / f"{tool_id}.json"
