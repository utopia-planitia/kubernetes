HCLOUD_NODES_PREFIX ?= $(shell git rev-parse --abbrev-ref HEAD)
HCLOUD_KEYPAIR_NAME ?= $(shell hostname -s)
HCLOUD_DATACENTER ?= fsn1-dc8

.PHONY: hcloud-provision
hcloud-provision: ##@hcloud start vms and create inventory (set export HCLOUD_TOKEN=YOURAPITOKEN before)
	$(CLI) ansible-playbook hcloud-provision.yml -e "region_name=$(HCLOUD_DATACENTER) HCLOUD_NODES_PREFIX=$(HCLOUD_NODES_PREFIX) HCLOUD_KEYPAIR_NAME=$(HCLOUD_KEYPAIR_NAME)" ${ANSIBLE_OPTIONS}

.PHONY: hcloud-destroy
hcloud-destroy: ##@hcloud stop and remove vms
	$(CLI) ansible-playbook hcloud-destroy.yml -e "HCLOUD_NODES_PREFIX=$(HCLOUD_NODES_PREFIX) HCLOUD_KEYPAIR_NAME=$(HCLOUD_KEYPAIR_NAME)" ${ANSIBLE_OPTIONS}
