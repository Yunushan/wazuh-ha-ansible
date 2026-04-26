# Wazuh HA Ansible — Tiếng Việt

<div>

Dự án tự động hóa cluster Wazuh high-availability có thể điều chỉnh cho 3 node hoặc triển khai enterprise lớn hơn.

## Overview

Repository này cài Wazuh indexer, manager master/workers, dashboard và load balancer HAProxy hoặc NGINX bằng Ansible và Wazuh installation assistant chính thức.

## Kiến trúc mặc định

Inventory mặc định chạy cluster hội tụ 3 node: mỗi node có thể chạy indexer, vai trò manager, dashboard và ứng viên load balancer. Các triển khai tách lớp lớn hơn cũng được hỗ trợ.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## Bắt đầu nhanh

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## Hỗ trợ distribution

Các mục tiêu central component chính thức của Wazuh được tách khỏi mục tiêu community/lab. Hãy xem docs/SUPPORT_MATRIX.md trước khi dùng production.

## Bảo mật

Không commit mật khẩu, certificate, private key hoặc production inventory được tạo ra. Thư mục .secure được Git bỏ qua.

## Giấy phép

Dự án automation này phát hành theo MIT License. Wazuh vẫn theo license riêng của nó.

</div>
