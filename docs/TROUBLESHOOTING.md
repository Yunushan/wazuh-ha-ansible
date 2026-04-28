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
tail -n 100 /var/log/wazuh-indexer/wazuh-indexer-cluster.log
ls -l /etc/wazuh-indexer/certs
```

Expected `vm.max_map_count` is at least `262144`.

If Java reports that it cannot open `/var/log/wazuh-indexer/gc.log`, recreate the log directory:

```bash
install -d -o wazuh-indexer -g wazuh-indexer -m 0750 /var/log/wazuh-indexer
systemctl start wazuh-indexer
```

If the install task reports `changed=0` and the service start fails, the node likely has a partial or failed previous indexer installation. Inspect `/var/log/wazuh-install.log` and the Wazuh indexer journal on that node before removing or reinstalling anything.

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
tail -n 120 /var/ossec/logs/ossec.log
/var/ossec/bin/wazuh-control status
```

If `wazuh-manager` times out during first startup, increase the service startup window in inventory:

```yaml
wazuh_manager_start_timeout_sec: 300
```

If `wazuh-authd` reports that it cannot bind port `1515`, check for an existing load balancer listener on converged hosts:

```bash
ss -lntp | grep -E '1514|1515|55000'
systemctl stop haproxy nginx
```

Then set non-conflicting frontend ports in inventory before rerunning the load-balancer playbook:

```yaml
wazuh_lb_agent_events_frontend_port: 15140
wazuh_lb_agent_enrollment_frontend_port: 15150
wazuh_lb_api_frontend_port: 55001
```

In the converged inventory, the dashboard load-balancer frontend also moves away from the local dashboard service port by default. Use `https://<vip>:8443` unless you intentionally move the local dashboard service to a different backend port and keep the load balancer on `443`:

```yaml
wazuh_dashboard_port: 8443
wazuh_lb_dashboard_frontend_port: 443
```

If the VIP answers with `Connection refused`, find the VIP owner and confirm HAProxy or NGINX is active there:

```bash
ansible -i inventory/production.yml wazuh_loadbalancers -b -m shell -a "ip -o addr show dev ens33; systemctl is-active keepalived haproxy; ss -lntp | grep -E ':443|:8443|:15140|:15150|:55001'"
```

Keepalived should release the VIP when the local load-balancer process is down. Re-run the load-balancer playbook if `/etc/keepalived/keepalived.conf` still has a small positive `weight` in `vrrp_script chk_lb`.

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

If `systemctl restart haproxy` fails on nodes that also run Wazuh manager or dashboard services, check for listener conflicts:

```bash
ss -lntp | grep -E '1514|1515|443|55000|9200'
journalctl -u haproxy -n 100 --no-pager
```

Converged nodes cannot have HAProxy and the local Wazuh services listen on the same wildcard ports at the same time. Use dedicated load-balancer hosts for standard ports, or set non-conflicting frontend ports in inventory:

```yaml
wazuh_lb_agent_events_frontend_port: 15140
wazuh_lb_agent_enrollment_frontend_port: 15150
wazuh_lb_api_frontend_port: 55001
wazuh_lb_dashboard_frontend_port: 8443
```

## NGINX stream config fails

Some distributions package the NGINX stream module separately. On Debian/Ubuntu this project attempts to install `libnginx-mod-stream`.

Validate:

```bash
nginx -t
```
