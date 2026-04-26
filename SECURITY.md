# Security Policy

## Reporting security issues

Do not open public issues for sensitive vulnerabilities or exposed secrets. Contact the maintainers privately in your own repository fork or organization process.

## Sensitive files

The following must never be committed:

- `.secure/`
- `wazuh-install-files.tar`
- `wazuh-passwords.txt`
- certificate private keys
- production inventories with secrets
- Ansible Vault password files

## Production hardening checklist

- Use SSH keys and restrict SSH source networks.
- Use Ansible Vault for sensitive variables.
- Use firewall rules/security groups for Wazuh ports.
- Avoid exposing indexer port `9200` to untrusted networks.
- Replace self-signed dashboard TLS with a trusted certificate where required.
- Store generated Wazuh credentials in a password manager.
- Test Wazuh upgrades in staging first.
- Back up indexer data and configuration before changes.
