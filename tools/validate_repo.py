#!/usr/bin/env python3
"""Lightweight repository validation for Wazuh HA Ansible."""
from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    "README.md",
    "LICENSE",
    "ansible.cfg",
    "requirements.txt",
    "requirements.yml",
    "playbooks/site.yml",
    "inventory/3-node-converged.example.yml",
    "inventory/enterprise-separated.example.yml",
    "docs/SUPPORT_MATRIX.md",
    "docs/i18n/README.en.md",
    "roles/wazuh_generator/templates/config.yml.j2",
    "roles/load_balancer/templates/haproxy.cfg.j2",
]

LANGS = ["en", "zh", "hi", "es", "fr", "ar", "bn", "pt", "ru", "ur", "id", "de", "ja", "tr", "ko", "vi", "it", "fa", "pl", "uk"]


def main() -> int:
    missing = [p for p in REQUIRED if not (ROOT / p).exists()]
    missing_langs = [lang for lang in LANGS if not (ROOT / f"docs/i18n/README.{lang}.md").exists()]

    if missing or missing_langs:
        if missing:
            print("Missing required files:")
            for p in missing:
                print(f"  - {p}")
        if missing_langs:
            print("Missing localized READMEs:")
            for lang in missing_langs:
                print(f"  - {lang}")
        return 1

    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    if "0BSD" not in readme or "Wazuh" not in readme:
        print("README does not contain expected project markers")
        return 1

    print("Repository validation passed.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
