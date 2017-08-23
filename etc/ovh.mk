CURRENT_GIT_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
OVH_KEYPAIR_NAME = $(shell hostname | base64 -w 0)

.PHONY: ovh-provision
ovh-provision: ##@ovh start vms and create inventory
	$(CLI) ansible-playbook ovh-provision.yml -e "OVH_NODES_PREFIX=$(CURRENT_GIT_BRANCH) OVH_KEYPAIR_NAME=$(OVH_KEYPAIR_NAME)" ${ANSIBLE_OPTIONS}

.PHONY: ovh-destroy
ovh-destroy: ##@ovh stop and remove vms
	$(CLI) ansible-playbook ovh-destroy.yml -e "OVH_NODES_PREFIX=$(CURRENT_GIT_BRANCH) OVH_KEYPAIR_NAME=$(OVH_KEYPAIR_NAME)" ${ANSIBLE_OPTIONS}
