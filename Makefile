.PHONY: help deps preflight deploy verify lint clean package

INVENTORY ?= inventory/3-node-converged.example.yml

help:
	@echo "Wazuh HA Ansible"
	@echo "  make deps       Install Python and Ansible collection dependencies"
	@echo "  make preflight  Run preflight checks"
	@echo "  make deploy     Deploy full Wazuh HA cluster"
	@echo "  make verify     Run verification checks"
	@echo "  make lint       Validate repository structure"
	@echo "  make clean      Remove local generated artifacts"
	@echo "  make package    Build a zip archive"

deps:
	python3 -m pip install -r requirements.txt
	ansible-galaxy collection install -r requirements.yml

preflight:
	ansible-playbook -i $(INVENTORY) playbooks/preflight.yml

deploy:
	ansible-playbook -i $(INVENTORY) playbooks/site.yml

verify:
	ansible-playbook -i $(INVENTORY) playbooks/verify.yml

lint:
	python3 tools/validate_repo.py

clean:
	rm -rf .secure build dist *.retry

package:
	mkdir -p dist
	zip -r dist/wazuh-ha-ansible.zip . -x "*.git*" ".secure/*" "dist/*" "*.retry"
