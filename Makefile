export VM_OS ?= bento-16.04


# thanks to https://gist.github.com/prwhite/8168133#gistcomment-1727513 for 'make help'
.PHONY: help
help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

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

#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (sort keys %help) { \
	print "${WHITE}$$_:${RESET}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
	}; \
	print "\n"; }
