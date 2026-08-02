# Wazuh HA Ansible — हिन्दी

<div>

3-नोड और बड़े एंटरप्राइज़ डिप्लॉयमेंट के लिए समायोज्य Wazuh हाई-अवेलेबिलिटी क्लस्टर ऑटोमेशन प्रोजेक्ट।

## Overview

यह रिपॉज़िटरी Ansible और आधिकारिक Wazuh installation assistant से indexer, manager master/workers, dashboards और HAProxy या NGINX load balancers इंस्टॉल करती है।

## डिफ़ॉल्ट आर्किटेक्चर

डिफ़ॉल्ट inventory एक converged 3-node cluster चलाती है: हर node indexer, manager role, dashboard और load-balancer candidate चला सकता है। बड़े separated deployments भी समर्थित हैं।

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## त्वरित शुरुआत

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## डिस्ट्रिब्यूशन समर्थन

Official Wazuh central-component targets को community या lab targets से अलग दिखाया गया है। production से पहले docs/SUPPORT_MATRIX.md देखें।

## सुरक्षा

Generated passwords, certificates, private keys या production inventories commit न करें। .secure directory Git द्वारा ignore की गई है।

## लाइसेंस

यह automation project 0BSD License के अंतर्गत जारी है। Wazuh स्वयं अपनी licenses के अंतर्गत रहता है।

</div>
