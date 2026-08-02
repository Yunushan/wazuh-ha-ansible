# Wazuh HA Ansible — Español

<div>

Proyecto de automatización para clúster Wazuh de alta disponibilidad, ajustable para 3 nodos o despliegues empresariales mayores.

## Overview

Este repositorio instala indexers de Wazuh, managers master/workers, dashboards y balanceadores HAProxy o NGINX usando Ansible y el asistente oficial de instalación de Wazuh.

## Arquitectura predeterminada

El inventario predeterminado ejecuta un clúster convergente de 3 nodos: cada nodo puede ejecutar indexer, rol de manager, dashboard y candidato de balanceador. También admite despliegues separados más grandes.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Inicio rápido

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Soporte de distribuciones

Los objetivos oficiales para componentes centrales de Wazuh se separan de los objetivos comunitarios o de laboratorio. Revise docs/SUPPORT_MATRIX.md antes de producción.

## Seguridad

Nunca confirme contraseñas generadas, certificados, claves privadas ni inventarios de producción. El directorio .secure está ignorado por Git.

## Licencia

Este proyecto de automatización se publica bajo licencia 0BSD. Wazuh conserva sus propias licencias.

</div>
