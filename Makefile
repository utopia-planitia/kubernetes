
include ./etc/make-help.mk

export VM_OS ?= bento-16.04

.PHONY: system-requirements-check
system-requirements-check: ##@setup checks system for required dependencies
	@./etc/system-requirements-check.sh

.PHONY: cli
cli: ##@development creates command line interface
	@docker run -ti -v $(PWD):/workspace -w /workspace davedamoon/k8s-cluster-build-tools:v1.11

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
