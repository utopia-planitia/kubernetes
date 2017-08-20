
DEV_TOOLS_DOCKER_IMAGE_PREBUILD ?= davedamoon/kubernetes-cluster-dev-tools
DEV_TOOLS_DOCKER_IMAGE_LOCAL ?= kubernetes-cluster-dev-tools
DEV_TOOLS_DOCKER_IMAGE_EXISTS = $(shell which docker && docker images -q ${DEV_TOOLS_DOCKER_IMAGE_LOCAL})
DEV_TOOLS_DOCKER_IMAGE = $(shell [ "${DEV_TOOLS_DOCKER_IMAGE_EXISTS}" ] && echo ${DEV_TOOLS_DOCKER_IMAGE_LOCAL} || echo ${DEV_TOOLS_DOCKER_IMAGE_PREBUILD})
CLI_HOST = docker run --net=host --rm -ti -v $(PWD):/workspace -v ~/.ssh:/root/.ssh -v ~/.vagrant.d/:/root/.vagrant.d/ -w /workspace ${DEV_TOOLS_DOCKER_IMAGE}
CLI_DOCKER = ""
CLI = $(shell [ "$(shell cat /proc/1/cgroup | grep docker)" ] && echo ${CLI_DOCKER} || echo ${CLI_HOST})

.PHONY: build-cli-image
build-cli-image: ##@development creates command line interface
	docker build --pull -t ${DEV_TOOLS_DOCKER_IMAGE_LOCAL} ./docker

.PHONY: delete-cli-image
delete-cli-image: ##@development removes the local cli image
	docker rmi ${DEV_TOOLS_DOCKER_IMAGE_LOCAL}

.PHONY: cli
cli: ##@development creates command line interface
	$(CLI) bash
