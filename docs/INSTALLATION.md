# Installation Guide

This guide assumes an Ansible control node and three target servers.

## 1. Prepare the control node

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
```

## 2. Prepare SSH access

The control node must be able to SSH to each target host and use privilege escalation.

```bash
ssh-copy-id ubuntu@10.10.10.11
ssh-copy-id ubuntu@10.10.10.12
ssh-copy-id ubuntu@10.10.10.13
```

## 3. Create a production inventory

```bash
cp inventory/3-node-converged.example.yml inventory/production.yml
```

Edit:

- `ansible_user`
- `ansible_host`
- `wazuh_node_ip`
- `wazuh_lb_virtual_ip`
- `wazuh_keepalived_interface`
- `wazuh_keepalived_auth_pass`

## 4. Run preflight

```bash
ansible-playbook -i inventory/production.yml playbooks/preflight.yml --ask-become-pass
```

## 5. Generate Wazuh installation files

```bash
ansible-playbook -i inventory/production.yml playbooks/generate.yml --ask-become-pass
```

This creates `.secure/wazuh/wazuh-install-files.tar` on the controller.

## 6. Distribute installation files

```bash
ansible-playbook -i inventory/production.yml playbooks/distribute.yml --ask-become-pass
```

## 7. Install indexers

```bash
ansible-playbook -i inventory/production.yml playbooks/install-indexers.yml --ask-become-pass
```

## 8. Install managers

```bash
ansible-playbook -i inventory/production.yml playbooks/install-managers.yml --ask-become-pass
```

## 9. Install dashboards

```bash
ansible-playbook -i inventory/production.yml playbooks/install-dashboards.yml --ask-become-pass
```

## 10. Install load balancers

```bash
ansible-playbook -i inventory/production.yml playbooks/install-loadbalancers.yml --ask-become-pass
```

## 11. Verify

```bash
ansible-playbook -i inventory/production.yml playbooks/verify.yml --ask-become-pass
```

## Full deployment command

After you have tested the inventory, you can run everything:

```bash
ansible-playbook -i inventory/production.yml playbooks/site.yml --ask-become-pass
```

## Credentials

Extract the generated passwords:

```bash
tar -O -xvf .secure/wazuh/wazuh-install-files.tar \
  wazuh-install-files/wazuh-passwords.txt
```

Store them in a password manager and restrict access to `.secure/`.
