
DEV_TOOLS_DOCKER_IMAGE ?= registry.gitlab.com/davedamoon/kubernetes-via-ansible
CLI_HOST = docker run --net=host --rm -ti -v $(PWD):/workspace -v ~/.ssh/ovh:/root/.ssh -v ~/.vagrant.d/:/root/.vagrant.d/ -w /workspace -e KUBECONFIG=/workspace/certificates/master/admin-kube-config ${DEV_TOOLS_DOCKER_IMAGE}
CLI_DOCKER = ""
CLI = $(shell [ "$(shell cat /proc/1/cgroup | grep docker)" ] && echo ${CLI_DOCKER} || echo ${CLI_HOST})

.PHONY: build-cli-image
build-cli-image: ##@development build DEV_TOOLS_DOCKER_IMAGE from docker directory
	docker build --pull -t ${DEV_TOOLS_DOCKER_IMAGE} ./docker

.PHONY: pull-cli-image
pull-cli-image: ##@development pull latest version of DEV_TOOLS_DOCKER_IMAGE
	docker pull ${DEV_TOOLS_DOCKER_IMAGE}

.PHONY: delete-cli-image
delete-cli-image: ##@development removes the local DEV_TOOLS_DOCKER_IMAGE
	docker rmi ${DEV_TOOLS_DOCKER_IMAGE}

.PHONY: cli
cli: ##@development creates command line interface
	$(CLI) bash
