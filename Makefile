
include ./etc/make-help.mk

export VM_OS ?= bento-16.04

.PHONY: system-requirements-check
system-requirements-check: ##@setup checks system for required dependencies
	@./etc/system-requirements-check.sh

.PHONY: cli
cli: ##@development creates command line interface
	@docker build --pull -t kubernetes-tools ./docker
	@docker run --net=host --rm -ti -v $(PWD):/workspace -w /workspace kubernetes-tools

.PHONY: deploy
deploy: ##@ansible deploy
	@ansible-playbook playbook.yml ${OPTIONS}

.PHONY: update
update: ##@vms start vms
	vagrant box update

.PHONY: start
start: ##@vms start vms
	./etc/parallel-up.sh

.PHONY: stop
stop: ##@vms stop vms
	./etc/parallel-halt.sh

.PHONY: clean
clean: ##@vms stop and remove vms
	./etc/parallel-destroy.sh
