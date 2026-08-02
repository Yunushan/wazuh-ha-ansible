# Wazuh HA Ansible — Українська

<div>

Гнучкий проєкт автоматизації високодоступного кластера Wazuh для 3 вузлів і більших корпоративних розгортань.

## Overview

Репозиторій встановлює Wazuh indexer, manager master/workers, dashboards і балансувальники HAProxy або NGINX за допомогою Ansible та офіційного Wazuh installation assistant.

## Типова архітектура

Типовий inventory запускає конвергентний 3-вузловий кластер: кожен вузол може виконувати indexer, роль manager, dashboard і кандидата load balancer. Також підтримуються більші розділені розгортання.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Швидкий старт

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Підтримка дистрибутивів

Офіційні цілі центральних компонентів Wazuh відокремлені від community/lab цілей. Перед production перегляньте docs/SUPPORT_MATRIX.md.

## Безпека

Не комітьте згенеровані паролі, сертифікати, приватні ключі або production inventory. Каталог .secure ігнорується Git.

## Ліцензія

Цей проєкт автоматизації випущено за 0BSD License. Wazuh залишається під власними ліцензіями.

</div>
