# Wazuh HA Ansible — Bahasa Indonesia

<div>

Proyek otomasi cluster Wazuh high-availability yang dapat disesuaikan untuk 3 node dan deployment enterprise yang lebih besar.

## Overview

Repository ini memasang Wazuh indexer, manager master/workers, dashboard, serta load balancer HAProxy atau NGINX memakai Ansible dan Wazuh installation assistant resmi.

## Arsitektur default

Inventory default menjalankan cluster konvergen 3 node: setiap node dapat menjalankan indexer, peran manager, dashboard, dan kandidat load balancer. Deployment terpisah yang lebih besar juga didukung.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Mulai cepat

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Dukungan distribusi

Target resmi komponen pusat Wazuh dipisahkan dari target komunitas atau lab. Tinjau docs/SUPPORT_MATRIX.md sebelum produksi.

## Keamanan

Jangan commit password, sertifikat, private key, atau inventory produksi yang dihasilkan. Direktori .secure diabaikan oleh Git.

## Lisensi

Proyek otomasi ini dirilis dengan Lisensi MIT. Wazuh tetap mengikuti lisensinya sendiri.

</div>
