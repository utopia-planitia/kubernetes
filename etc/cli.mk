
IS_CONTAINERIZED =
ifneq ($(shell uname), Darwin)
  ifneq ($(shell cat /proc/1/cgroup | grep docker | wc -l), 0)
    IS_CONTAINERIZED = yes
  endif
  ifneq ($(shell cat /proc/1/cgroup | grep kubepods | wc -l), 0)
    IS_CONTAINERIZED = yes
  endif
endif

DOCKER_INTERACTIVE ?= -i

CLI =
ifndef IS_CONTAINERIZED
  CLI_MK_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
  KUBERNETES_TOOLS_IMAGE ?= $(shell docker build -q -f $(CLI_MK_DIR)/../docker/dev-tools/Dockerfile $(CLI_MK_DIR)/..)
  KUBERNETES_E2E_IMAGE ?= $(shell docker build -q $(CLI_MK_DIR)/../docker/e2e-tests)

  DOCKER ?= docker
  DOCKER_OPTIONS += -v $(PWD):/workspace -w /workspace

  # ssh
  DOCKER_OPTIONS += $(shell [ ! -z "$(SSH_AUTH_SOCK)" ] && echo -v $(SSH_AUTH_SOCK):$(SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$(SSH_AUTH_SOCK))
  DOCKER_OPTIONS += -v ~/.vagrant.d/:/root/.vagrant.d/

  # digital ocean
  DOCKER_OPTIONS += -e DO_API_TOKEN=$(DO_API_TOKEN)
  DOCKER_OPTIONS += -v ~/.ssh/digital-ocean:/root/.ssh/digital-ocean

  # ovh
  DOCKER_OPTIONS += -v ~/.ssh/ovh:/root/.ssh/ovh

  # make status
  DOCKER_OPTIONS += -v $(shell realpath $(CLI_MK_DIR)):/kubernetes/etc

  # ansible
  ifneq ("$(wildcard roles)","")
    NEED_ANSIBLE ?= yes
  endif

  ifdef NEED_ANSIBLE
    ifneq ("$(wildcard $(CLI_MK_DIR)/../../../ansible)","")
      ANSIBLE_PATH = $(shell realpath $(CLI_MK_DIR)/../../../ansible)
      DOCKER_OPTIONS += -v $(ANSIBLE_PATH)/ansible.cfg:/workspace/ansible.cfg
      DOCKER_OPTIONS += -v $(ANSIBLE_PATH)/inventory:/workspace/inventory
      $(shell touch inventory)
      DOCKER_OPTIONS += -v $(ANSIBLE_PATH)/group_vars:/workspace/group_vars
      DOCKER_OPTIONS += -v $(ANSIBLE_PATH)/host_vars:/workspace/host_vars
    endif
  endif

  # configurations
  KUBERNETES_CONFIG_PATH = $(shell realpath $(CLI_MK_DIR)/..)
  ifneq ("$(wildcard $(CLI_MK_DIR)/../../../ansible)","")
    KUBERNETES_CONFIG_PATH = $(shell realpath $(CLI_MK_DIR)/../../../)/configurations/kubernetes
  endif

  KUBECONFIG ?= /certificates/master/admin-kube-config
  DOCKER_OPTIONS += -e KUBECONFIG=$(KUBECONFIG)
  DOCKER_OPTIONS += -v $(KUBERNETES_CONFIG_PATH)/certificates:/certificates

  CLI = $(DOCKER) run --net=host --rm -t $(DOCKER_INTERACTIVE) $(DOCKER_OPTIONS) $(KUBERNETES_TOOLS_IMAGE)
  E2E = $(DOCKER) run --net=host --rm -t $(DOCKER_INTERACTIVE) $(DOCKER_OPTIONS) $(KUBERNETES_E2E_IMAGE)
endif

CMD ?= bash

.PHONY: cli
cli: ##@development creates admin command line interface
	$(CLI) $(CMD)

.PHONY: e2e-cli
e2e-cli: ##@development creates end to end testing command line interface
	$(E2E) $(CMD)

.PHONY: demo-cli
demo-cli: ##@development creates user command line interface
	$(CLI) sh -c "KUBECONFIG=/workspace/certificates/user/demo-user-kube-config bash"

.PHONY: status
status: ##@development show current system status
	@$(CLI) /kubernetes/etc/status.sh
