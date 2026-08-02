# Wazuh HA Ansible — বাংলা

<div>

৩-নোড এবং বড় এন্টারপ্রাইজ ডিপ্লয়মেন্টের জন্য সমন্বয়যোগ্য Wazuh high-availability cluster automation project।

## Overview

এই repository Ansible এবং official Wazuh installation assistant ব্যবহার করে indexer, manager master/workers, dashboards এবং HAProxy বা NGINX load balancers ইনস্টল করে।

## ডিফল্ট আর্কিটেকচার

ডিফল্ট inventory একটি converged 3-node cluster চালায়: প্রতিটি node indexer, manager role, dashboard এবং load-balancer candidate চালাতে পারে। বড় separated deployment-ও সমর্থিত।

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## দ্রুত শুরু

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## ডিস্ট্রিবিউশন সমর্থন

Official Wazuh central-component targets community/lab targets থেকে আলাদা করা হয়েছে। production ব্যবহারের আগে docs/SUPPORT_MATRIX.md দেখুন।

## নিরাপত্তা

Generated passwords, certificates, private keys বা production inventories commit করবেন না। .secure directory Git ignore করে।

## লাইসেন্স

এই automation project 0BSD License এর অধীনে প্রকাশিত। Wazuh নিজস্ব license অনুসরণ করে।

</div>
