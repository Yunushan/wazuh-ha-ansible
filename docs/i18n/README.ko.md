# Wazuh HA Ansible — 한국어

<div>

3노드 및 더 큰 엔터프라이즈 배포를 위한 조정 가능한 Wazuh 고가용성 클러스터 자동화 프로젝트입니다.

## Overview

이 저장소는 Ansible과 공식 Wazuh 설치 도우미를 사용하여 indexer, manager master/workers, dashboard, HAProxy 또는 NGINX 로드 밸런서를 설치합니다.

## 기본 아키텍처

기본 인벤토리는 통합형 3노드 클러스터입니다. 각 노드는 indexer, manager 역할, dashboard, load balancer 후보를 실행할 수 있습니다. 더 큰 분리형 배포도 지원합니다.

```text
VIP / DNS
  ├─ wazuh-a: indexer-1 + manager master + dashboard + load balancer
  ├─ wazuh-b: indexer-2 + manager worker + dashboard + load balancer
  └─ wazuh-c: indexer-3 + manager worker + dashboard + load balancer
```

## 빠른 시작

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventory/3-node-converged.example.yml inventory/production.yml
ansible-playbook -i inventory/production.yml playbooks/preflight.yml
ansible-playbook -i inventory/production.yml playbooks/site.yml
```

## 배포판 지원

공식 Wazuh 중앙 컴포넌트 대상과 community/lab 대상을 구분합니다. 운영 환경 전에 docs/SUPPORT_MATRIX.md를 확인하세요.

## 보안

생성된 비밀번호, 인증서, 개인 키, 운영 inventory를 커밋하지 마세요. .secure 디렉터리는 Git에서 제외됩니다.

## 라이선스

이 자동화 프로젝트는 0BSD License로 배포됩니다. Wazuh 자체는 별도 라이선스를 따릅니다.

</div>
