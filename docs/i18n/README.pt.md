# Wazuh HA Ansible — Português

<div>

Projeto de automação para cluster Wazuh de alta disponibilidade, ajustável para 3 nós ou implantações empresariais maiores.

## Overview

Este repositório instala indexers Wazuh, managers master/workers, dashboards e balanceadores HAProxy ou NGINX usando Ansible e o assistente oficial de instalação do Wazuh.

## Arquitetura padrão

O inventário padrão executa um cluster convergente de 3 nós: cada nó pode executar indexer, função de manager, dashboard e candidato de balanceador. Implantações separadas maiores também são suportadas.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Início rápido

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Suporte a distribuições

Os alvos oficiais de componentes centrais do Wazuh são separados dos alvos comunitários ou de laboratório. Revise docs/SUPPORT_MATRIX.md antes da produção.

## Segurança

Nunca faça commit de senhas geradas, certificados, chaves privadas ou inventários de produção. O diretório .secure é ignorado pelo Git.

## Licença

Este projeto de automação é lançado sob a Licença MIT. O Wazuh permanece sob suas próprias licenças.

</div>
