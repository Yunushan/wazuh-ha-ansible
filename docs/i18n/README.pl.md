# Wazuh HA Ansible — Polski

<div>

Regulowany projekt automatyzacji klastra Wazuh wysokiej dostępności dla 3 węzłów i większych wdrożeń enterprise.

## Overview

Repozytorium instaluje Wazuh indexery, manager master/workers, dashboardy oraz load balancery HAProxy lub NGINX przy użyciu Ansible i oficjalnego asystenta instalacji Wazuh.

## Domyślna architektura

Domyślny inventory uruchamia zbieżny klaster 3-węzłowy: każdy węzeł może uruchamiać indexer, rolę managera, dashboard i kandydata load balancera. Obsługiwane są też większe wdrożenia rozdzielone.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Szybki start

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Wsparcie dystrybucji

Oficjalne cele centralnych komponentów Wazuh są oddzielone od celów community/lab. Przed produkcją sprawdź docs/SUPPORT_MATRIX.md.

## Bezpieczeństwo

Nie commituj wygenerowanych haseł, certyfikatów, kluczy prywatnych ani inventory produkcyjnych. Katalog .secure jest ignorowany przez Git.

## Licencja

Ten projekt automatyzacji jest wydany na licencji MIT. Wazuh pozostaje na własnych licencjach.

</div>
