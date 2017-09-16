
include ./etc/help.mk
include ./etc/cli.mk
include ./etc/ovh.mk
include ./etc/vagrant/vagrant.mk

#ANSIBLE_OPTIONS ?= "-vvvv"

.PHONY: system-requirements-check
system-requirements-check: ##@setup checks system for required dependencies
	./etc/system-requirements-check.sh

.PHONY: certificates
certificates:
	$(CLI) ansible-playbook certificates.yml ${ANSIBLE_OPTIONS}

.PHONY: deploy
deploy: ##@ansible deploy to nodes
	$(CLI) ansible-playbook certificates.yml ${ANSIBLE_OPTIONS}
	$(CLI) ansible-playbook deploy.yml       ${ANSIBLE_OPTIONS}
	$(CLI) bash etc/wait-for-nodes.sh
	$(CLI) kubectl apply -f addons/ -f certificates/addons/
	$(CLI) bash etc/wait-for-addons.sh

.PHONY: lint
lint: ##@ansible lint ansible config
	$(CLI) ansible-lint *.yml roles

.PHONY: tests
tests: ##@development run all tests
	$(CLI) bats tests/*

.PHONY: status
status: ##@development show current system status
	$(CLI) ./etc/status.sh
