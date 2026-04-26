#!/usr/bin/env bash
set -euo pipefail

if [[ ! -r /etc/os-release ]]; then
  echo "unknown: /etc/os-release not found"
  exit 1
fi

. /etc/os-release
id="${ID:-unknown}"
version="${VERSION_ID:-rolling}"
major="${version%%.*}"

case "$id:$major" in
  amzn:2|amzn:2023|centos:10|rhel:7|rhel:8|rhel:9|rhel:10|ubuntu:16|ubuntu:18|ubuntu:20|ubuntu:22|ubuntu:24)
    echo "official-central: $PRETTY_NAME"
    ;;
  debian:11|debian:12|debian:13|rocky:7|rocky:8|rocky:9|rocky:10|almalinux:7|almalinux:8|almalinux:9|almalinux:10|ol:7|ol:8|ol:9|ol:10|fedora:42|fedora:43)
    echo "community-central: $PRETTY_NAME"
    ;;
  arch:*|manjaro:*|kali:*|parrot:*|tails:*|qubes:*|alpine:*)
    echo "lab-or-agent-only: $PRETTY_NAME"
    ;;
  *)
    echo "unsupported-or-unclassified: $PRETTY_NAME"
    exit 2
    ;;
esac
