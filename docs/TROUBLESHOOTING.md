# Troubleshooting

## The installer cannot find `wazuh-install-files.tar`

Run:

```bash
ansible-playbook -i inventory/production.yml playbooks/generate.yml
ansible-playbook -i inventory/production.yml playbooks/distribute.yml
```

Check:

```bash
ls -l .secure/wazuh/
```

## Indexer does not start

Check:

```bash
sysctl vm.max_map_count
systemctl status wazuh-indexer
journalctl -u wazuh-indexer -n 100 --no-pager
```

Expected `vm.max_map_count` is at least `262144`.

## Manager cluster problems

Check node types in inventory:

```yaml
wazuh_manager_type: master
wazuh_manager_type: worker
```

Only one manager should be master.

On the manager:

```bash
/var/ossec/bin/cluster_control -l
journalctl -u wazuh-manager -n 100 --no-pager
```

## Agents cannot enroll

Check that the load balancer forwards `1515/tcp` to the manager master.

```bash
nc -vz <vip-or-lb> 1515
```

## Agents enroll but do not send data

Check that `1514/tcp` is balanced to worker managers.

```bash
nc -vz <vip-or-lb> 1514
```

## Dashboard unavailable

Check:

```bash
systemctl status wazuh-dashboard
ss -lntp | grep 443
journalctl -u wazuh-dashboard -n 100 --no-pager
```

## HAProxy config fails

Validate manually:

```bash
haproxy -c -f /etc/haproxy/haproxy.cfg
```

## NGINX stream config fails

Some distributions package the NGINX stream module separately. On Debian/Ubuntu this project attempts to install `libnginx-mod-stream`.

Validate:

```bash
nginx -t
```
