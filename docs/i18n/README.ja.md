# Wazuh HA Ansible — 日本語

<div>

3ノード構成およびより大規模なエンタープライズ展開向けの、調整可能な Wazuh 高可用性クラスター自動化プロジェクトです。

## Overview

このリポジトリは Ansible と公式 Wazuh インストールアシスタントを使い、indexer、manager master/workers、dashboard、HAProxy または NGINX ロードバランサーをインストールします。

## デフォルト構成

デフォルト inventory は統合型 3 ノードクラスターです。各ノードは indexer、manager ロール、dashboard、ロードバランサー候補を実行できます。より大きな分離構成にも対応します。

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## クイックスタート

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## ディストリビューション対応

公式 Wazuh 中央コンポーネント対象と community/lab 対象を分けています。本番利用前に docs/SUPPORT_MATRIX.md を確認してください。

## セキュリティ

生成されたパスワード、証明書、秘密鍵、本番 inventory をコミットしないでください。.secure ディレクトリは Git で無視されます。

## ライセンス

この自動化プロジェクトは 0BSD License で公開されています。Wazuh 本体は独自のライセンスに従います。

</div>
