# Wazuh HA Ansible — 中文

<div>

用于 3 节点和更大企业部署的可调整 Wazuh 高可用集群自动化项目。

## Overview

本仓库使用 Ansible 和官方 Wazuh 安装助手安装 indexer、manager 主/工作节点、dashboard，以及 HAProxy 或 NGINX 负载均衡器。

## 默认架构

默认清单是融合式 3 节点集群：每个节点都可以运行 indexer、manager 角色、dashboard 和负载均衡候选服务。也支持更大的分离式企业部署。

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## 快速开始

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## 发行版支持

项目区分官方 Wazuh 中央组件目标和社区/实验室目标。生产使用前请查看 docs/SUPPORT_MATRIX.md。

## 安全

不要提交生成的密码、证书、私钥或生产清单。.secure 目录已被 Git 忽略。

## 许可证

本自动化项目采用 0BSD 许可证。Wazuh 本身仍遵循其自己的许可证。

</div>
