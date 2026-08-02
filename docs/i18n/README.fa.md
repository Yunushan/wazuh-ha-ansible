# Wazuh HA Ansible — فارسی

<div dir="rtl">

پروژه اتوماسیون قابل تنظیم برای کلاستر Wazuh با دسترس‌پذیری بالا در ۳ نود یا استقرارهای سازمانی بزرگ‌تر.

## Overview

این مخزن با Ansible و نصب‌کننده رسمی Wazuh، اجزای indexer، manager master/workers، dashboard و load balancerهای HAProxy یا NGINX را نصب می‌کند.

## معماری پیش‌فرض

Inventory پیش‌فرض یک کلاستر converged سه‌نودی اجرا می‌کند: هر نود می‌تواند indexer، نقش manager، dashboard و کاندید load balancer را اجرا کند. استقرارهای جداشده بزرگ‌تر نیز پشتیبانی می‌شوند.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## شروع سریع

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## پشتیبانی توزیع‌ها

اهداف رسمی central componentهای Wazuh از اهداف community/lab جدا شده‌اند. قبل از production فایل docs/SUPPORT_MATRIX.md را بررسی کنید.

## امنیت

رمزهای تولیدشده، گواهی‌ها، کلیدهای خصوصی یا inventoryهای production را commit نکنید. دایرکتوری .secure توسط Git نادیده گرفته می‌شود.

## مجوز

این پروژه اتوماسیون تحت 0BSD License منتشر شده است. Wazuh تحت مجوزهای خودش باقی می‌ماند.

</div>
