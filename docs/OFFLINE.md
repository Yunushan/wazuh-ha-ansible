# Offline and Air-gapped Notes

This project defaults to the online Wazuh installation assistant flow. For restricted environments, adapt the workflow as follows.

## Suggested offline flow

1. On an internet-connected staging host, download required Wazuh packages and the installation assistant.
2. Create or mirror OS repositories for your target distributions.
3. Copy `wazuh-install.sh`, `config.yml`, and required packages to the secure network.
4. Set `wazuh_controller_artifacts_dir` to a local path containing the assistant and generated bundle.
5. Run playbooks with external downloads disabled or pre-staged.

## Variables to review

```yaml
wazuh_version: "4.14"
wazuh_install_workdir: "/opt/wazuh-ha-install"
wazuh_controller_artifacts_dir: "{{ playbook_dir }}/../.secure/wazuh"
```

## Production advice

For highly regulated environments, prefer a dedicated internal package mirror and use Ansible Vault or an enterprise secrets manager for any credentials.
