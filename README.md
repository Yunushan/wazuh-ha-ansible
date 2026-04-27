# Wazuh HA Ansible

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Automation](https://img.shields.io/badge/Automation-Ansible-blue.svg)](playbooks/site.yml)
[![Wazuh](https://img.shields.io/badge/Wazuh-4.14%20ready-purple.svg)](docs/REFERENCES.md)
[![Topology](https://img.shields.io/badge/Topology-3%20node%20adjustable-orange.svg)](docs/ARCHITECTURE.md)
[![Load balancing](https://img.shields.io/badge/LB-HAProxy%20%7C%20NGINX-lightgrey.svg)](roles/load_balancer)

**Wazuh HA Ansible** is a GitHub-ready automation project for deploying a **full high-availability Wazuh cluster**. The default example is a **3-node converged HA topology**, and the inventory can be adjusted for larger separated enterprise deployments.

This repository follows a clean open-source layout: MIT license, issue templates, security policy, contribution guide, Ansible playbooks, role-based automation, examples, operational documentation, and localized README files in 20 widely used languages.

> This project is an independent automation wrapper. It does not redistribute Wazuh binaries and is not affiliated with Wazuh, Inc. Wazuh packages, installers, and components remain governed by their own licenses and documentation.

---

## Table of contents

1. [What this project installs](#what-this-project-installs)
2. [Default 3-node HA architecture](#default-3-node-ha-architecture)
3. [Quick start](#quick-start)
4. [Adjusting node count](#adjusting-node-count)
5. [Supported Linux distributions](#supported-linux-distributions)
6. [Project layout](#project-layout)
7. [Playbooks](#playbooks)
8. [Security notes](#security-notes)
9. [Documentation](#documentation)
10. [Localized READMEs](#localized-readmes)
11. [License](#license)

---

## What this project installs

The automation can install and configure:

- **Wazuh indexer cluster** with 3 nodes by default.
- **Wazuh server / manager cluster** with 1 master and 2 workers by default.
- **Wazuh dashboard** on one or more nodes.
- **HAProxy or NGINX** TCP load balancing for Wazuh agent traffic.
- Optional **Keepalived VIP** for load-balancer high availability.
- Common kernel and dependency preparation such as `vm.max_map_count` for indexer nodes.
- Generated Wazuh certificate/password bundle through the official Wazuh installation assistant.

The playbooks use the official assisted-installation flow:

1. Render `config.yml` from your Ansible inventory.
2. Download the Wazuh installation assistant.
3. Generate `wazuh-install-files.tar`.
4. Copy the generated bundle to all Wazuh nodes.
5. Install indexers.
6. Initialize the indexer cluster once.
7. Install manager master/workers.
8. Install dashboards.
9. Install and configure load balancers.
10. Run health checks.

---

## Default 3-node HA architecture

The default inventory is **converged**: each of the three servers can run multiple Wazuh roles.

```text
                    +------------------------------+
                    |  Virtual IP / DNS name        |
                    |  HAProxy or NGINX + optional  |
                    |  Keepalived                   |
                    +---------------+--------------+
                                    |
        +---------------------------+---------------------------+
        |                           |                           |
+-------+--------+          +-------+--------+          +-------+--------+
| wazuh-a        |          | wazuh-b        |          | wazuh-c        |
| indexer-1      |          | indexer-2      |          | indexer-3      |
| manager master |          | manager worker |          | manager worker |
| dashboard-1    |          | dashboard-2    |          | dashboard-3    |
| LB candidate   |          | LB candidate   |          | LB candidate   |
+----------------+          +----------------+          +----------------+
```

Default front-door ports:

| Port | Purpose | Backend behavior |
|---:|---|---|
| `1514/tcp` | Agent event traffic | Balanced to manager workers by default |
| `1515/tcp` | Agent enrollment | Forwarded to the manager master |
| `443/tcp` or configured dashboard port | Dashboard HTTPS | Balanced to dashboard nodes |
| `55000/tcp` | Wazuh API | Usually master-first or manager pool |
| `9200/tcp` | Indexer API | Not exposed by default unless enabled |

For stricter enterprise separation, use `inventory/enterprise-separated.example.yml`, where indexers, managers, dashboards, and load balancers are distinct hosts.

---

## Quick start

### 1. Install controller dependencies

Run these commands on your Ansible control node:

```bash
git clone https://github.com/YOUR_ORG/wazuh-ha-ansible.git
cd wazuh-ha-ansible

python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
```

### 2. Create your inventory

```bash
cp inventory/3-node-converged.example.yml inventory/production.yml
nano inventory/production.yml
```

Change at least:

- `ansible_host`
- `wazuh_node_ip`
- SSH user settings
- `wazuh_lb_virtual_ip` if using Keepalived
- dashboard port if needed
- Wazuh version selector if needed
- node names if you want a custom naming scheme

Version selector examples:

```yaml
# Default stable channel selected by this project.
wazuh_version: "stable"

# Same current channel behavior, installs the latest patch available in 4.14.
wazuh_version: "4.14"

# Exact package patch pin. The playbook downloads the 4.14 assistant and pins it to 4.14.5 before distribution.
wazuh_version: "4.14.5"

# Alias targets can be overridden when Wazuh publishes a new channel.
wazuh_stable_version: "4.14"
wazuh_latest_version: "4.14"
```

Ubuntu apt source repair is enabled by default. If an Ubuntu image still uses HTTP package sources, the common role rewrites official Ubuntu archive/security URLs to HTTPS before package installation:

```yaml
wazuh_fix_apt_http_sources: true
```

### 3. Run preflight

```bash
ansible-playbook -i inventory/production.yml playbooks/preflight.yml --ask-become-pass
```

### 4. Deploy the full cluster

```bash
ansible-playbook -i inventory/production.yml playbooks/site.yml --ask-become-pass
```

For converged inventories where indexer, manager, and dashboard components share the same nodes, keep the Wazuh package repository enabled until every Wazuh component is installed. This project disables Wazuh repositories at the end of `playbooks/site.yml` through `playbooks/disable-repos.yml`. If you run component playbooks separately, run `playbooks/disable-repos.yml` only after the last Wazuh component playbook finishes.

### 5. Verify the deployment

```bash
ansible-playbook -i inventory/production.yml playbooks/verify.yml --ask-become-pass
```

### 6. Retrieve generated credentials

The official Wazuh installation assistant stores generated passwords inside `wazuh-install-files.tar`. This project fetches the bundle into `.secure/wazuh/` on your controller and never commits it.

```bash
tar -O -xvf .secure/wazuh/wazuh-install-files.tar \
  wazuh-install-files/wazuh-passwords.txt
```

---

## Adjusting node count

This project is not hardcoded to 3 nodes. To scale up or down:

1. Add or remove hosts from the inventory groups:
   - `wazuh_indexers`
   - `wazuh_managers`
   - `wazuh_dashboards`
   - `wazuh_loadbalancers`
2. Give each component a unique name:
   - `wazuh_indexer_name`
   - `wazuh_manager_name`
   - `wazuh_dashboard_name`
3. Use exactly one manager with `wazuh_manager_type: master`.
4. Use one or more managers with `wazuh_manager_type: worker`.
5. Keep at least 3 indexers for an HA production baseline.
6. Add at least 2 load balancers plus a VIP if you want the load-balancer layer to be HA.

Examples:

```bash
# Full default run
ansible-playbook -i inventory/production.yml playbooks/site.yml

# Only install indexers
ansible-playbook -i inventory/production.yml playbooks/install-indexers.yml

# Only install managers
ansible-playbook -i inventory/production.yml playbooks/install-managers.yml

# Only configure load balancers
ansible-playbook -i inventory/production.yml playbooks/install-loadbalancers.yml
```

---

## Supported Linux distributions

The project includes the complete distro list requested by the user, but separates it into two truthful categories:

- **Official central-component targets**: operating systems currently listed in the Wazuh central-component documentation.
- **Community / compatibility targets**: distributions this project can bootstrap or attempt using family-compatible package logic, but which are not claimed here as official Wazuh central-component targets.

See the full matrix: [docs/SUPPORT_MATRIX.md](docs/SUPPORT_MATRIX.md)

Important examples:

| Distribution family | Central component status in this project |
|---|---|
| Amazon Linux 2 / 2023 | Official Wazuh central-component target |
| CentOS Stream 10 | Official Wazuh central-component target |
| RHEL 7 / 8 / 9 / 10 | Official Wazuh central-component target |
| Ubuntu 16.04 / 18.04 / 20.04 / 22.04 / 24.04 | Official Wazuh central-component target |
| Ubuntu 26.04 | Community / future target until official Wazuh support is confirmed |
| Debian 11 / 12 / 13 | Community apt-compatible target |
| Rocky / Alma / Oracle Linux 7-10 | Community RHEL-compatible target |
| Fedora 42 / 43 | Community dnf-compatible target |
| Arch / Manjaro | Community, not recommended for central production |
| Kali / Parrot / Tails / Qubes | Lab/security-distro targets; not recommended for central production |
| Alpine | Agent/container/source-only style target; not recommended for central production |

---

## Project layout

```text
wazuh-ha-ansible/
├── .github/                    # CI and issue templates
├── docs/                       # Architecture, installation, operations, translations
├── inventory/                  # Adjustable example inventories
├── playbooks/                  # Main Ansible playbooks
├── roles/                      # Ansible roles for Wazuh and HA services
├── scripts/                    # Helper scripts
├── tools/                      # Repository validation helpers
├── ansible.cfg                 # Local Ansible defaults
├── requirements.txt            # Python dependencies for controller
├── requirements.yml            # Ansible collection dependencies
├── Makefile                    # Common commands
├── LICENSE                     # MIT license for this automation project
└── README.md                   # Main English README
```

---

## Playbooks

| Playbook | Purpose |
|---|---|
| `playbooks/preflight.yml` | Validate OS family, architecture, privileges, package manager, and common prerequisites |
| `playbooks/generate.yml` | Generate Wazuh config, certificates, and password bundle |
| `playbooks/distribute.yml` | Copy the generated installation bundle to all Wazuh nodes |
| `playbooks/install-indexers.yml` | Install Wazuh indexers and initialize the cluster once |
| `playbooks/install-managers.yml` | Install Wazuh manager master and workers |
| `playbooks/install-dashboards.yml` | Install one or more Wazuh dashboard nodes |
| `playbooks/disable-repos.yml` | Disable Wazuh package repositories after all Wazuh components are installed |
| `playbooks/install-loadbalancers.yml` | Configure HAProxy or NGINX, optionally with Keepalived VIP |
| `playbooks/verify.yml` | Perform basic port and service checks |
| `playbooks/site.yml` | Full end-to-end deployment |
| `playbooks/uninstall.yml` | Best-effort cleanup using the Wazuh assistant uninstall option |

---

## Security notes

- Never commit `.secure/`, `wazuh-install-files.tar`, generated passwords, certificates, private keys, or production inventories with secrets.
- Run this automation from a trusted control node.
- Restrict SSH access to the target servers.
- Restrict indexer API access to trusted networks.
- Use a trusted TLS certificate for production dashboard access.
- Place load balancers and Wazuh nodes behind firewalls/security groups.
- Review apt source repair behavior before production if your environment requires a private Ubuntu mirror.
- Disable Wazuh package repositories after all Wazuh components are installed if you do not want accidental upgrades.
- Test upgrades in staging before production.

---

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Installation Guide](docs/INSTALLATION.md)
- [Support Matrix](docs/SUPPORT_MATRIX.md)
- [Operations Guide](docs/OPERATIONS.md)
- [Offline / Air-gapped Notes](docs/OFFLINE.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [References](docs/REFERENCES.md)
- [Project Name Ideas](docs/NAMING_IDEAS.md)

---

## Localized READMEs

| Language | File |
|---|---|
| English | [docs/i18n/README.en.md](docs/i18n/README.en.md) |
| 中文 | [docs/i18n/README.zh.md](docs/i18n/README.zh.md) |
| हिन्दी | [docs/i18n/README.hi.md](docs/i18n/README.hi.md) |
| Español | [docs/i18n/README.es.md](docs/i18n/README.es.md) |
| Français | [docs/i18n/README.fr.md](docs/i18n/README.fr.md) |
| العربية | [docs/i18n/README.ar.md](docs/i18n/README.ar.md) |
| বাংলা | [docs/i18n/README.bn.md](docs/i18n/README.bn.md) |
| Português | [docs/i18n/README.pt.md](docs/i18n/README.pt.md) |
| Русский | [docs/i18n/README.ru.md](docs/i18n/README.ru.md) |
| اردو | [docs/i18n/README.ur.md](docs/i18n/README.ur.md) |
| Bahasa Indonesia | [docs/i18n/README.id.md](docs/i18n/README.id.md) |
| Deutsch | [docs/i18n/README.de.md](docs/i18n/README.de.md) |
| 日本語 | [docs/i18n/README.ja.md](docs/i18n/README.ja.md) |
| Türkçe | [docs/i18n/README.tr.md](docs/i18n/README.tr.md) |
| 한국어 | [docs/i18n/README.ko.md](docs/i18n/README.ko.md) |
| Tiếng Việt | [docs/i18n/README.vi.md](docs/i18n/README.vi.md) |
| Italiano | [docs/i18n/README.it.md](docs/i18n/README.it.md) |
| فارسی | [docs/i18n/README.fa.md](docs/i18n/README.fa.md) |
| Polski | [docs/i18n/README.pl.md](docs/i18n/README.pl.md) |
| Українська | [docs/i18n/README.uk.md](docs/i18n/README.uk.md) |

---

## License

This automation project is released under the [MIT License](LICENSE).

Wazuh itself is not relicensed by this repository. Review Wazuh’s own licenses and documentation before production use.
