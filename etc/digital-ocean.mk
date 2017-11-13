DIGITAL_OCEAN_NODES_PREFIX ?= $(shell git rev-parse --abbrev-ref HEAD)
DIGITAL_OCEAN_KEYPAIR_NAME ?= $(shell hostname -s)
DIGITAL_OCEAN_REGION_NAME ?= fra1

.PHONY: digital-ocean-provision
digital-ocean-provision: ##@digital-ocean start vms and create inventory
	$(CLI) touch inventory
	$(CLI) ansible-playbook digital-ocean-provision.yml -e "region_name=$(DIGITAL_OCEAN_REGION_NAME) DIGITAL_OCEAN_NODES_PREFIX=$(DIGITAL_OCEAN_NODES_PREFIX) DIGITAL_OCEAN_KEYPAIR_NAME=$(DIGITAL_OCEAN_KEYPAIR_NAME)" ${ANSIBLE_OPTIONS}

.PHONY: digital-ocean-destroy
digital-ocean-destroy: ##@digital-ocean stop and remove vms
	$(CLI) ansible-playbook digital-ocean-destroy.yml -e "DIGITAL_OCEAN_NODES_PREFIX=$(DIGITAL_OCEAN_NODES_PREFIX) DIGITAL_OCEAN_KEYPAIR_NAME=$(DIGITAL_OCEAN_KEYPAIR_NAME)" ${ANSIBLE_OPTIONS}
