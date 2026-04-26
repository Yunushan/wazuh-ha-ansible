# Linux Distribution Support Matrix

This matrix includes the operating systems requested for this project.

Legend:

- **Official central**: currently listed by Wazuh documentation for central components.
- **Community central**: this project includes family-compatible automation logic, but the distro is not claimed as an official Wazuh central-component target here.
- **Lab / agent / special**: suitable for agents, labs, templates, containers, or special workflows; not recommended for production central components.
- **Future / verify first**: do not use for production central components until official support is confirmed.

| Distribution | Versions | Project status | Notes |
|---|---:|---|---|
| Amazon Linux | 2, 2023 | Official central | Use RPM/YUM/DNF path. Good for AWS deployments. |
| CentOS Stream | 10 | Official central | Use RPM/DNF path. |
| Red Hat Enterprise Linux | 7, 8, 9, 10 | Official central | Use RPM/YUM/DNF path. |
| Ubuntu | 16.04, 18.04, 20.04, 22.04, 24.04 | Official central | Use APT path. |
| Ubuntu | 26.04 | Future / verify first | Requested, but not listed in current Wazuh central-component docs used for this project. |
| Debian | 11, 12, 13 | Community central | APT-compatible; test before production. |
| Rocky Linux | 7, 8, 9, 10 | Community central | RHEL-compatible; test before production. |
| Alma Linux | 7, 8, 9, 10 | Community central | RHEL-compatible; test before production. |
| Oracle Linux | 7, 8, 9, 10 | Community central | RHEL-compatible; UEK-specific behavior should be tested. |
| Fedora Linux | 42, 43 | Community central | Fast-moving distro; not ideal for long-term central components. |
| Arch Linux | rolling | Lab / agent / special | Rolling release; central components are best deployed on official server distros. |
| Manjaro Linux | rolling | Lab / agent / special | Rolling release; not recommended for central production. |
| Kali Linux | rolling | Lab / agent / special | Security workstation/lab OS; not recommended for central production. |
| Alpine Linux | rolling | Lab / agent / special | musl/OpenRC environment; use containers/source/agent workflows rather than central production. |
| Parrot Linux | rolling | Lab / agent / special | Security workstation/lab OS; not recommended for central production. |
| Tails Linux | rolling | Lab / agent / special | Ephemeral privacy OS; not appropriate for Wazuh central services. |
| Qubes OS | templates | Lab / agent / special | Use inside Fedora/Debian templates or dedicated VMs; not a simple central-component target. |

## Strict mode

By default, `wazuh_allow_unsupported_distros: false` blocks hosts outside the official/community matrix.

For lab experiments only:

```yaml
wazuh_allow_unsupported_distros: true
```

## Recommendation

For enterprise central components, prefer:

- Amazon Linux 2023
- RHEL 9/10
- Ubuntu 22.04/24.04
- CentOS Stream 10 where appropriate

Use rolling or security-focused distributions for agents, labs, or disposable test environments, not for the central SIEM cluster.
