
IMAGE_TAG ?= v5
DEV_TOOLS_DOCKER_IMAGE ?= registry.gitlab.com/$(shell basename $(shell dirname $(PWD)))/kubernetes-tools:${IMAGE_TAG}
CLI_HOST = docker run --net=host --rm -ti -v $(PWD):/workspace -v ~/.ssh/ovh:/root/.ssh -v ~/.vagrant.d/:/root/.vagrant.d/ -w /workspace -e KUBECONFIG=/workspace/certificates/master/admin-kube-config ${DEV_TOOLS_DOCKER_IMAGE}
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
