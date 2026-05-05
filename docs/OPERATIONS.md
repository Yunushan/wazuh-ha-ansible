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

## HA validation runbook

Run the HA validation playbook after deployment changes and before planned
maintenance windows:

```bash
ansible-playbook -i inventory/production.yml playbooks/ha-validation.yml --ask-become-pass
```

The default run is non-disruptive. It validates:

- Wazuh indexer, manager, Filebeat, dashboard, load balancer, and Keepalived services.
- Single VIP ownership.
- Load-balanced frontend ports.
- Manager cluster membership.
- Indexer cluster health and expected node count.

For a controlled VIP failover test, stop Keepalived on the current VIP owner
through the playbook and let another load balancer take over:

```bash
ansible-playbook -i inventory/production.yml playbooks/ha-validation.yml \
  -e wazuh_ha_validation_controlled_failover_enabled=true \
  -e wazuh_ha_validation_controlled_failover_confirm=RUN_WAZUH_CONTROLLED_FAILOVER \
  --ask-become-pass
```

This does not hard-power a node. Use hard-power tests only after backups and
only during a maintenance window. With three total converged nodes, one-node
failure should remain available; two-node failure is outside the safe design
target because the indexer cluster and Wazuh manager topology lose quorum or
critical roles.

## Monitoring and alerting

For a maximum three-node design, install node-local checks on every Wazuh node.
This does not replace external monitoring, but it gives you fast visibility
without adding infrastructure:

```bash
ansible-playbook -i inventory/production.yml playbooks/configure-monitoring.yml --ask-become-pass
```

The playbook installs:

- `/usr/local/sbin/wazuh-ha-monitor`
- `wazuh-ha-monitor.service`
- `wazuh-ha-monitor.timer`

The monitor checks local Wazuh services, load balancer health, VIP frontend
ports, disk pressure, manager cluster membership, and indexer cluster health.
Failures are written to the journal/syslog:

```bash
systemctl status wazuh-ha-monitor.timer
journalctl -t wazuh-ha-monitor --since "1 hour ago"
systemctl list-timers wazuh-ha-monitor.timer
```

Optional webhook alerts can be enabled from inventory:

```yaml
wazuh_ha_monitoring_webhook_url: https://alerts.example.com/wazuh-ha
wazuh_ha_monitoring_interval: 60s
wazuh_ha_monitoring_disk_warning_percent: 85
wazuh_ha_monitoring_disk_critical_percent: 95
```

Alert immediately on these conditions:

- `wazuh-indexer`, `wazuh-manager`, `filebeat`, `wazuh-dashboard`, `haproxy`, `nginx`, or `keepalived` inactive.
- VIP frontend ports unreachable.
- Indexer health not green when all three nodes should be up.
- Manager cluster membership below expected count.
- Disk usage above warning or critical thresholds.

## Production DNS and TLS

Use stable DNS names for users and agents, and point them to the Keepalived
VIP, not to an individual Wazuh node. For dashboard access, install the same
certificate and private key on every dashboard node so HAProxy/NGINX can keep
TCP pass-through.

```yaml
wazuh_dashboard_public_fqdn: wazuh.example.com
wazuh_dashboard_public_url: https://wazuh.example.com
wazuh_agent_public_fqdn: agents.wazuh.example.com
wazuh_dashboard_tls_enabled: true
wazuh_dashboard_tls_cert_src: files/tls/wazuh-fullchain.pem
wazuh_dashboard_tls_key_src: files/tls/wazuh-key.pem
```

```bash
ansible-playbook -i inventory/production.yml playbooks/configure-dashboard-tls.yml --ask-become-pass
ansible-playbook -i inventory/production.yml playbooks/install-loadbalancers.yml --ask-become-pass
```

After DNS is live and the issuing CA is trusted by your controller, enable the
production endpoint checks:

```yaml
wazuh_dashboard_verify_public_dns: true
wazuh_dashboard_verify_public_tls: true
wazuh_dashboard_verify_tls_validate_certs: true
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

Run the config/secrets backup playbook regularly:

```bash
ansible-playbook -i inventory/production.yml playbooks/backup.yml --ask-become-pass
```

For alert/index data, use an indexer snapshot repository. A filesystem
repository must be mounted and usable on every indexer node. Local-only disks
are not enough for disaster recovery because losing that node also loses the
snapshot.

```yaml
wazuh_indexer_snapshot_repository_enabled: true
wazuh_indexer_snapshot_path: /mnt/wazuh-indexer-snapshots
```

```bash
ansible-playbook -i inventory/production.yml playbooks/configure-indexer-snapshot-repository.yml --ask-become-pass
ansible-playbook -i inventory/production.yml playbooks/create-indexer-snapshot.yml --ask-become-pass
```

Snapshot restore is also guarded and restores into `restored-*` indices by
default. Keep the rename behavior for test restores:

```bash
ansible-playbook -i inventory/production.yml playbooks/restore-indexer-snapshot.yml \
  -e wazuh_indexer_snapshot_restore_confirm=RESTORE_WAZUH_INDEXER_SNAPSHOT \
  -e wazuh_indexer_snapshot_restore_name=wazuh-snapshot-YYYYMMDDTHHMMSSZ \
  --ask-become-pass
```

Config restore is intentionally guarded. Pass the exact confirmation string and
set per-host backup archive paths:

```bash
ansible-playbook -i inventory/production.yml playbooks/restore-configs.yml \
  -e wazuh_restore_confirm=RESTORE_WAZUH_CONFIGS \
  -e '{"wazuh_restore_archive_src_map":{"wazuh-1":"/path/to/wazuh-1.tar.gz","wazuh-2":"/path/to/wazuh-2.tar.gz","wazuh-3":"/path/to/wazuh-3.tar.gz"}}' \
  --ask-become-pass
```

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
