# References

This project is designed around the official Wazuh assisted installation model and cluster documentation.

Key upstream topics to review before production:

- Wazuh quickstart and installation guide.
- Wazuh indexer installation and multi-node cluster initialization.
- Wazuh server / manager cluster documentation.
- Wazuh dashboard installation.
- Wazuh load balancer recommendations for manager clusters.
- Wazuh package repository and upgrade guidance.

Important notes reflected in this repository:

- The Wazuh indexer can be deployed in a cluster for scalability, high availability, and performance.
- The Wazuh server cluster supports a master/worker model and can be combined with a network load balancer.
- The official assisted installation flow uses `config.yml`, generates `wazuh-install-files.tar`, installs indexers, initializes the cluster once, then installs server and dashboard components.
- The Wazuh documentation recommends disabling Wazuh package repositories after installation to avoid accidental upgrades.
- This automation project is MIT licensed; Wazuh itself remains under its own licenses.

Upstream URLs are intentionally not hardcoded into every role except the official package endpoint used by the installer:

```text
https://packages.wazuh.com/<version>/wazuh-install.sh
```

Default version in this project:

```yaml
wazuh_version: "4.14"
```
