# Architecture

Wazuh HA Ansible supports two primary deployment styles.

## 1. Three-node converged HA

This is the default example. It is useful when you want a compact production baseline with three servers.

| Node | Indexer | Manager | Dashboard | Load balancer |
|---|---|---|---|---|
| `wazuh-a` | `indexer-1` | `manager-1` master | `dashboard-1` | HAProxy/NGINX + Keepalived candidate |
| `wazuh-b` | `indexer-2` | `manager-2` worker | `dashboard-2` | HAProxy/NGINX + Keepalived candidate |
| `wazuh-c` | `indexer-3` | `manager-3` worker | `dashboard-3` | HAProxy/NGINX + Keepalived candidate |

### Why this works

- Three indexers provide quorum-friendly storage clustering.
- One manager master coordinates the manager cluster.
- Worker managers handle agent event load.
- Multiple dashboards can be balanced behind HAProxy/NGINX.
- Keepalived can move a VIP between load-balancer candidates.

## 2. Separated enterprise HA

Use dedicated hosts for each layer when throughput, compliance, or isolation matters.

```text
load balancers:  lb-1, lb-2
managers:        mgr-1 master, mgr-2 worker, mgr-3 worker
indexers:        idx-1, idx-2, idx-3
dashboards:      dash-1, dash-2
```

This is easier to scale and maintain because each layer can be patched, monitored, and resized independently.

## Traffic flow

```text
Agents -> VIP/DNS -> 1514/tcp -> manager workers
Agents -> VIP/DNS -> 1515/tcp -> manager master
Users  -> VIP/DNS -> 443/tcp  -> dashboard nodes
Admins -> VIP/DNS -> 55000/tcp -> Wazuh API
Managers -> indexers -> 9200/tcp internal only
```

## Ports

| Port | Protocol | Component | Notes |
|---:|---|---|---|
| 1514 | TCP | Wazuh manager | Agent event traffic |
| 1515 | TCP | Wazuh manager | Agent enrollment |
| 514 | UDP/TCP | Wazuh manager | Optional syslog use case; not enabled by default in HAProxy |
| 55000 | TCP | Wazuh API | Restrict to admin networks |
| 9200 | TCP | Wazuh indexer | Keep internal unless explicitly needed |
| 9300 | TCP | Wazuh indexer | Indexer transport / cluster communication |
| 443 | TCP | Wazuh dashboard | Can be changed with `wazuh_dashboard_port` |

## Sizing guidance

For an enterprise-grade deployment, start with at least:

- Indexer nodes: 16 GB RAM and 8 CPU cores each where possible.
- Manager nodes: 4 GB RAM and 8 CPU cores each where possible.
- Storage: calculate based on agents, alert volume, and retention.
- Network: low latency between manager and indexer layers.

## Scaling

Add nodes by editing inventory groups and rerunning the relevant playbook. Keep one manager master. Add workers for event ingestion. Add indexers for storage and search capacity. Add dashboards for web UI redundancy.
