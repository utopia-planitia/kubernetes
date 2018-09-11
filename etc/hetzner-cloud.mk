DIGITAL_OCEAN_NODES_PREFIX ?= $(shell git rev-parse --abbrev-ref HEAD)
DIGITAL_OCEAN_KEYPAIR_NAME ?= $(shell hostname -s)
HCLOUD_DATACENTER ?= fsn1-dc8

.PHONY: hcloud-provision
hcloud-provision: ##@hcloud start vms and create inventory
	$(CLI) touch inventory
	$(CLI) ansible-playbook hcloud-provision.yml -e "region_name=$(HCLOUD_DATACENTER) DIGITAL_OCEAN_NODES_PREFIX=$(DIGITAL_OCEAN_NODES_PREFIX) DIGITAL_OCEAN_KEYPAIR_NAME=$(DIGITAL_OCEAN_KEYPAIR_NAME)" ${ANSIBLE_OPTIONS}

.PHONY: hcloud-destroy
hcloud-destroy: ##@hcloud stop and remove vms
	$(CLI) ansible-playbook hcloud-destroy.yml -e "DIGITAL_OCEAN_NODES_PREFIX=$(DIGITAL_OCEAN_NODES_PREFIX) DIGITAL_OCEAN_KEYPAIR_NAME=$(DIGITAL_OCEAN_KEYPAIR_NAME)" ${ANSIBLE_OPTIONS}
