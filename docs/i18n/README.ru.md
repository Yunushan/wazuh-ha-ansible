# Wazuh HA Ansible — Русский

<div>

Настраиваемый проект автоматизации высокодоступного кластера Wazuh для 3 узлов и более крупных корпоративных внедрений.

## Overview

Репозиторий устанавливает Wazuh indexer, manager master/workers, dashboards и балансировщики HAProxy или NGINX с помощью Ansible и официального установщика Wazuh.

## Архитектура по умолчанию

Инвентарь по умолчанию запускает конвергентный кластер из 3 узлов: каждый узел может выполнять indexer, роль manager, dashboard и кандидат load balancer. Также поддерживаются более крупные раздельные развертывания.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Быстрый старт

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Поддержка дистрибутивов

Официальные цели для центральных компонентов Wazuh отделены от community/lab целей. Перед production изучите docs/SUPPORT_MATRIX.md.

## Безопасность

Никогда не коммитьте сгенерированные пароли, сертификаты, приватные ключи или production inventory. Каталог .secure игнорируется Git.

## Лицензия

Этот проект автоматизации выпускается под лицензией MIT. Wazuh сохраняет собственные лицензии.

</div>
