# Wazuh HA Ansible — اردو

<div dir="rtl">

3 نوڈ اور بڑے انٹرپرائز deployments کے لیے قابلِ ترتیب Wazuh high-availability cluster automation project۔

## Overview

یہ repository Ansible اور official Wazuh installation assistant کے ذریعے indexers، manager master/workers، dashboards اور HAProxy یا NGINX load balancers انسٹال کرتی ہے۔

## ڈیفالٹ آرکیٹیکچر

Default inventory ایک converged 3-node cluster چلاتی ہے: ہر node indexer، manager role، dashboard اور load-balancer candidate چلا سکتا ہے۔ بڑے separated deployments بھی supported ہیں۔

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## فوری آغاز

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Distribution support

Official Wazuh central-component targets کو community/lab targets سے الگ رکھا گیا ہے۔ production سے پہلے docs/SUPPORT_MATRIX.md دیکھیں۔

## سیکیورٹی

Generated passwords، certificates، private keys یا production inventories commit نہ کریں۔ .secure directory Git میں ignore ہے۔

## لائسنس

یہ automation project 0BSD License کے تحت جاری ہے۔ Wazuh اپنی licenses کے تحت رہتا ہے۔

</div>
