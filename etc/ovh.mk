OVH_NODES_PREFIX ?= $(shell git rev-parse --abbrev-ref HEAD)
OVH_KEYPAIR_NAME ?= $(shell hostname -s)
OVH_REGION_NAME ?= SBG3

.PHONY: ovh-provision
ovh-provision: ##@ovh start vms and create inventory
	$(CLI) ansible-playbook ovh-provision.yml -e "region_name=$(OVH_REGION_NAME) OVH_NODES_PREFIX=$(OVH_NODES_PREFIX) OVH_KEYPAIR_NAME=$(OVH_KEYPAIR_NAME)" ${ANSIBLE_OPTIONS}

.PHONY: ovh-destroy
ovh-destroy: ##@ovh stop and remove vms
	$(CLI) ansible-playbook ovh-destroy.yml -e "OVH_NODES_PREFIX=$(OVH_NODES_PREFIX) OVH_KEYPAIR_NAME=$(OVH_KEYPAIR_NAME)" ${ANSIBLE_OPTIONS}
