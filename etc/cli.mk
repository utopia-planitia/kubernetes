
DEV_TOOLS_DOCKER_IMAGE_PREBUILD ?= davedamoon/kubernetes-cluster-dev-tools
DEV_TOOLS_DOCKER_IMAGE_LOCAL ?= kubernetes-cluster-dev-tools
DEV_TOOLS_DOCKER_IMAGE = $(shell [ $(shell docker images -q ${DEV_TOOLS_DOCKER_IMAGE_LOCAL}) ] && echo ${DEV_TOOLS_DOCKER_IMAGE_LOCAL} || echo ${DEV_TOOLS_DOCKER_IMAGE_PREBUILD})
CLI = docker run --net=host --rm -ti -v $(PWD):/workspace -w /workspace ${DEV_TOOLS_DOCKER_IMAGE}

.PHONY: build-cli-image
build-cli-image: ##@development creates command line interface
	docker build --pull -t ${DEV_TOOLS_DOCKER_IMAGE_LOCAL} ./docker

.PHONY: delete-cli-image
delete-cli-image: ##@development removes the local cli image
	docker rmi ${DEV_TOOLS_DOCKER_IMAGE_LOCAL}

.PHONY: cli
cli: ##@development creates command line interface
	$(CLI) bash
