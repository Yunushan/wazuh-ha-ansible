# Wazuh HA Ansible — Français

<div>

Projet d’automatisation pour un cluster Wazuh haute disponibilité, ajustable pour 3 nœuds ou des déploiements d’entreprise plus grands.

## Overview

Ce dépôt installe les indexers Wazuh, les managers master/workers, les dashboards et les équilibreurs HAProxy ou NGINX avec Ansible et l’assistant officiel d’installation Wazuh.

## Architecture par défaut

L’inventaire par défaut exécute un cluster convergé à 3 nœuds : chaque nœud peut exécuter un indexer, un rôle manager, un dashboard et un candidat load balancer. Les déploiements séparés plus grands sont aussi possibles.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Démarrage rapide

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Support des distributions

Les cibles officielles des composants centraux Wazuh sont séparées des cibles communautaires ou de laboratoire. Consultez docs/SUPPORT_MATRIX.md avant la production.

## Sécurité

Ne validez jamais les mots de passe générés, certificats, clés privées ou inventaires de production. Le dossier .secure est ignoré par Git.

## Licence

Ce projet d’automatisation est publié sous licence MIT. Wazuh conserve ses propres licences.

</div>
