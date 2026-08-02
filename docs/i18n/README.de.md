# Wazuh HA Ansible — Deutsch

<div>

Anpassbares Automatisierungsprojekt für einen hochverfügbaren Wazuh-Cluster mit 3 Knoten oder größeren Enterprise-Deployments.

## Overview

Dieses Repository installiert Wazuh Indexer, Manager Master/Worker, Dashboards sowie HAProxy- oder NGINX-Load-Balancer mit Ansible und dem offiziellen Wazuh Installation Assistant.

## Standardarchitektur

Das Standard-Inventar betreibt einen konvergenten 3-Knoten-Cluster: Jeder Knoten kann Indexer, Manager-Rolle, Dashboard und Load-Balancer-Kandidat ausführen. Größere getrennte Deployments werden ebenfalls unterstützt.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Schnellstart

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Distributionsunterstützung

Offizielle Ziele für zentrale Wazuh-Komponenten werden von Community- oder Laborzielen getrennt. Prüfen Sie docs/SUPPORT_MATRIX.md vor Produktionseinsatz.

## Sicherheit

Committen Sie niemals generierte Passwörter, Zertifikate, private Schlüssel oder Produktionsinventare. Das Verzeichnis .secure wird von Git ignoriert.

## Lizenz

Dieses Automatisierungsprojekt steht unter der 0BSD-Lizenz. Wazuh selbst bleibt unter seinen eigenen Lizenzen.

</div>
