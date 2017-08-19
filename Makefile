
include ./etc/help.mk
include ./etc/cli.mk
include ./etc/vagrant/vagrant.mk

.PHONY: system-requirements-check
system-requirements-check: ##@setup checks system for required dependencies
	@./etc/system-requirements-check.sh

.PHONY: deploy
deploy: ##@ansible deploy
	@ansible-playbook playbook.yml ${OPTIONS}
