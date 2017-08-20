
include ./etc/help.mk
include ./etc/cli.mk
include ./etc/ovh.mk
include ./etc/vagrant/vagrant.mk

#ANSIBLE_OPTIONS ?= "-vvvv"

.PHONY: system-requirements-check
system-requirements-check: ##@setup checks system for required dependencies
	./etc/system-requirements-check.sh

.PHONY: deploy
deploy: ##@ansible deploy
	$(CLI) ansible-playbook deploy.yml ${ANSIBLE_OPTIONS}
