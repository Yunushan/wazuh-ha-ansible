# Wazuh HA Ansible — العربية

<div dir="rtl">

مشروع أتمتة قابل للتعديل لنشر عنقود Wazuh عالي التوفر من 3 عقد أو أكثر لبيئات المؤسسات.

## Overview

يقوم هذا المستودع بتثبيت Wazuh indexers و manager master/workers ولوحات dashboard وموازنات HAProxy أو NGINX باستخدام Ansible ومساعد تثبيت Wazuh الرسمي.

## البنية الافتراضية

يعتمد المخزون الافتراضي على عنقود مدمج من 3 عقد: يمكن لكل عقدة تشغيل indexer ودور manager وdashboard ومرشح load balancer. كما يدعم النشر المنفصل الأكبر.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## بدء سريع

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## دعم التوزيعات

يتم فصل أهداف مكونات Wazuh المركزية الرسمية عن أهداف المجتمع أو المختبر. راجع docs/SUPPORT_MATRIX.md قبل الإنتاج.

## الأمان

لا تقم أبداً بإيداع كلمات المرور أو الشهادات أو المفاتيح الخاصة أو مخزونات الإنتاج. يتم تجاهل مجلد .secure بواسطة Git.

## الرخصة

هذا المشروع الآلي منشور برخصة 0BSD. يبقى Wazuh خاضعاً لرخصه الخاصة.

</div>
