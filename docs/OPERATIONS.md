# Operations Guide

## Daily checks

Run:

```bash
ansible-playbook -i inventory/production.yml playbooks/verify.yml
```

On nodes, check services:

```bash
systemctl status wazuh-indexer
systemctl status wazuh-manager
systemctl status filebeat
systemctl status wazuh-dashboard
systemctl status haproxy
systemctl status keepalived
```

## Indexer health

Use the generated admin password and run from a trusted network:

```bash
curl -k -u admin https://<indexer-ip>:9200/_cluster/health?pretty
curl -k -u admin https://<indexer-ip>:9200/_cat/nodes?v
```

## Manager health

```bash
/var/ossec/bin/cluster_control -l
/var/ossec/bin/agent_control -l
cat /var/ossec/var/run/wazuh-analysisd.state | grep events_dropped
cat /var/ossec/var/run/wazuh-remoted.state | grep discarded_count
```

## Load balancer health

```bash
systemctl status haproxy
ss -lntp | grep -E '1514|1515|443|55000'
```

If using Keepalived:

```bash
ip address show
systemctl status keepalived
```

## Backups

At minimum, back up:

- Wazuh indexer snapshots.
- `/var/ossec/etc/`
- `/etc/wazuh-indexer/`
- `/etc/wazuh-dashboard/`
- `/etc/filebeat/`
- `.secure/wazuh/wazuh-install-files.tar`
- production inventory and Ansible Vault files.

## Upgrades

Do not blindly upgrade packages in production. Recommended approach:

1. Snapshot/backup.
2. Test in staging.
3. Read Wazuh upgrade documentation for your exact version.
4. Upgrade one layer at a time.
5. Verify health after each stage.

## Adding manager workers

1. Add host to `wazuh_managers`.
2. Set `wazuh_manager_type: worker`.
3. Regenerate Wazuh installation files if certificates/config need to include the new node.
4. Run manager install and load balancer playbooks.

## Adding indexers

Adding indexers is more sensitive because certificates and cluster configuration matter. Follow Wazuh’s indexer cluster expansion documentation and test before production.
