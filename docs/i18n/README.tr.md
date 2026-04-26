# Wazuh HA Ansible — Türkçe

<div>

3 node ve daha büyük kurumsal dağıtımlar için ayarlanabilir Wazuh yüksek erişilebilirlik kümesi otomasyon projesi.

## Overview

Bu depo, Ansible ve resmi Wazuh kurulum yardımcısını kullanarak Wazuh indexer, manager master/worker, dashboard ve HAProxy ya da NGINX yük dengeleyicilerini kurar.

## Varsayılan mimari

Varsayılan envanter birleşik 3 node cluster çalıştırır: her node indexer, manager rolü, dashboard ve load balancer adayı çalıştırabilir. Daha büyük ayrık kurumsal kurulumlar da desteklenir.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Hızlı başlangıç

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Dağıtım desteği

Resmi Wazuh merkezi bileşen hedefleri, community/lab hedeflerinden ayrı gösterilir. Production öncesi docs/SUPPORT_MATRIX.md dosyasını inceleyin.

## Güvenlik

Üretilen parolaları, sertifikaları, private key dosyalarını veya production inventory dosyalarını commit etmeyin. .secure dizini Git tarafından yok sayılır.

## Lisans

Bu otomasyon projesi MIT Lisansı ile yayınlanmıştır. Wazuh kendi lisanslarına tabidir.

</div>
