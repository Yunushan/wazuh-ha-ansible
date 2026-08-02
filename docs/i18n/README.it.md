# Wazuh HA Ansible — Italiano

<div>

Progetto di automazione per cluster Wazuh ad alta disponibilità, regolabile per 3 nodi o deployment enterprise più grandi.

## Overview

Questo repository installa Wazuh indexer, manager master/workers, dashboard e bilanciatori HAProxy o NGINX usando Ansible e l’assistente ufficiale di installazione Wazuh.

## Architettura predefinita

L’inventario predefinito esegue un cluster convergente a 3 nodi: ogni nodo può eseguire indexer, ruolo manager, dashboard e candidato load balancer. Sono supportati anche deployment separati più grandi.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Avvio rapido

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Supporto distribuzioni

I target ufficiali dei componenti centrali Wazuh sono separati dai target community o lab. Controlla docs/SUPPORT_MATRIX.md prima della produzione.

## Sicurezza

Non committare password generate, certificati, chiavi private o inventari di produzione. La directory .secure è ignorata da Git.

## Licenza

Questo progetto di automazione è rilasciato con Licenza 0BSD. Wazuh mantiene le proprie licenze.

</div>
