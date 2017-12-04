
IMAGE_TAG ?= v5
DEV_TOOLS_DOCKER_IMAGE ?= registry.gitlab.com/$(shell basename $(shell dirname $(PWD)))/kubernetes-tools:${IMAGE_TAG}
DOCKER = docker
DOCKER_OPTIONS += -v $(PWD):/workspace -w /workspace
DOCKER_OPTIONS += $(shell [ ! -z "$(SSH_AUTH_SOCK)" ] && echo -v $(SSH_AUTH_SOCK):$(SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$(SSH_AUTH_SOCK))
DOCKER_OPTIONS += -v ~/.ssh/ovh:/root/.ssh/ovh
DOCKER_OPTIONS += -v ~/.vagrant.d/:/root/.vagrant.d/
DOCKER_OPTIONS += -e KUBECONFIG=/workspace/certificates/master/admin-kube-config
CLI_HOST = $(DOCKER) run --net=host --rm -ti $(DOCKER_OPTIONS) $(DEV_TOOLS_DOCKER_IMAGE)
CLI_DOCKER = ""
CLI = $(shell [ "$(shell cat /proc/1/cgroup | grep docker)" ] && echo ${CLI_DOCKER} || echo ${CLI_HOST})

.PHONY: cli-pull-image
cli-pull-image: ##@development pull latest version of DEV_TOOLS_DOCKER_IMAGE
	docker pull ${DEV_TOOLS_DOCKER_IMAGE}

.PHONY: cli
cli: ##@development creates admin command line interface
	$(CLI)

.PHONY: demo-cli
demo-cli: ##@development creates user command line interface
	$(CLI) sh -c "KUBECONFIG=/workspace/certificates/master/demo-user-kube-config bash"
