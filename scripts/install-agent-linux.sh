#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Install a Wazuh Linux agent with a manager/load-balancer address.

Usage:
  sudo ./scripts/install-agent-linux.sh <manager_or_lb_dns_or_ip> [agent_name] [agent_group]

Examples:
  sudo ./scripts/install-agent-linux.sh wazuh.example.com web-01 linux-servers
  sudo WAZUH_VERSION=4.14 ./scripts/install-agent-linux.sh 10.10.10.50
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

MANAGER="$1"
AGENT_NAME="${2:-$(hostname -s)}"
AGENT_GROUP="${3:-default}"
WAZUH_VERSION="${WAZUH_VERSION:-4.x}"

if [[ ! -r /etc/os-release ]]; then
  echo "Cannot detect distribution: /etc/os-release not found" >&2
  exit 1
fi
. /etc/os-release

install_deb() {
  apt-get update
  apt-get install -y curl gnupg apt-transport-https
  curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --dearmor -o /usr/share/keyrings/wazuh.gpg
  echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/${WAZUH_VERSION}/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list
  apt-get update
  WAZUH_MANAGER="$MANAGER" WAZUH_AGENT_NAME="$AGENT_NAME" WAZUH_AGENT_GROUP="$AGENT_GROUP" apt-get install -y wazuh-agent
  systemctl daemon-reload || true
  systemctl enable --now wazuh-agent || service wazuh-agent start
}

install_rpm() {
  rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH
  cat > /etc/yum.repos.d/wazuh.repo <<EOF
[wazuh]
gpgcheck=1
gpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH
enabled=1
name=EL-\$releasever - Wazuh
baseurl=https://packages.wazuh.com/${WAZUH_VERSION}/yum/
protect=1
EOF
  WAZUH_MANAGER="$MANAGER" WAZUH_AGENT_NAME="$AGENT_NAME" WAZUH_AGENT_GROUP="$AGENT_GROUP" yum install -y wazuh-agent || \
  WAZUH_MANAGER="$MANAGER" WAZUH_AGENT_NAME="$AGENT_NAME" WAZUH_AGENT_GROUP="$AGENT_GROUP" dnf install -y wazuh-agent
  systemctl daemon-reload || true
  systemctl enable --now wazuh-agent || service wazuh-agent start
}

case "${ID:-}" in
  ubuntu|debian|kali|parrot)
    install_deb
    ;;
  amzn|rhel|centos|rocky|almalinux|ol|fedora)
    install_rpm
    ;;
  *)
    echo "This helper supports deb/rpm package families. For ${PRETTY_NAME:-unknown}, use Wazuh docs or source/community packaging." >&2
    exit 2
    ;;
esac

echo "Wazuh agent installation requested for manager: $MANAGER"
