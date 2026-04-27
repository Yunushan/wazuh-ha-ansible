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
wazuh_version: "stable"
wazuh_stable_version: "4.14"
wazuh_latest_version: "4.14"
wazuh_install_workdir: "/opt/wazuh-ha-install"
wazuh_controller_artifacts_dir: "{{ playbook_dir }}/../.secure/wazuh"
```

`wazuh_version` accepts `stable`, `latest`, a major.minor channel such as `4.14`, or an exact patch such as `4.14.5`. Exact patch selections use the major.minor assistant channel and pin the downloaded assistant before it is copied to the Wazuh nodes.

## Production advice

For highly regulated environments, prefer a dedicated internal package mirror and use Ansible Vault or an enterprise secrets manager for any credentials.
