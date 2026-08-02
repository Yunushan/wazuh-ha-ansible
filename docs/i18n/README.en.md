# Wazuh HA Ansible — English

<div>

An adjustable high-availability Wazuh cluster automation project for 3-node and larger enterprise deployments.

## What this project does

This repository installs Wazuh indexers, manager master/workers, dashboards, and HAProxy or NGINX load balancers using Ansible and the official Wazuh installation assistant.

## Default architecture

The default inventory runs a converged 3-node cluster: every node can run an indexer, a manager role, a dashboard, and a load-balancer candidate. Larger separated deployments are also supported.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Quick start

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Distribution support

Official Wazuh central-component targets are separated from community or lab targets. Review docs/SUPPORT_MATRIX.md before production use.

## Security

Never commit generated passwords, certificates, private keys, or production inventories. The .secure directory is ignored by Git.

## License

This automation project is released under the 0BSD License. Wazuh itself remains under its own licenses.

</div>
