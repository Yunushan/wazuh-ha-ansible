# Contributing

Thank you for helping improve Wazuh HA Ansible.

## Development workflow

1. Fork the repository.
2. Create a feature branch.
3. Keep playbooks idempotent whenever possible.
4. Do not commit generated secrets, certificates, inventories with real IPs, or `wazuh-install-files.tar`.
5. Run repository validation:

```bash
python3 tools/validate_repo.py
```

6. Open a pull request with a clear explanation of the change.

## Style guidelines

- Prefer explicit Ansible task names.
- Keep distro-specific logic in roles, not in the main playbooks.
- Put operational explanations in `docs/`.
- Mark best-effort/community targets clearly.
- Avoid claiming official support unless the official Wazuh documentation lists it.

## Testing recommendations

Use disposable virtual machines first. A production-like test should include:

- 3 indexer nodes.
- 1 manager master.
- At least 1 manager worker.
- 1 or more dashboards.
- Load balancer health checks.
- Agent enrollment through the load balancer.
