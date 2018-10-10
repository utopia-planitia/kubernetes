
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
  KUBERNETES_TOOLS_IMAGE ?= $(shell docker build -q $(CLI_MK_DIR)/../docker/dev-tools)
  KUBERNETES_E2E_IMAGE ?= $(shell docker build -q $(CLI_MK_DIR)/../docker/e2e-tests)

  ifneq ("$(wildcard roles)","")
    NEED_ANSIBLE ?= yes
  endif

  DOCKER ?= docker
  DOCKER_OPTIONS += -v $(PWD):/workspace -w /workspace

  # ssh
  ifneq ($(shell uname), Darwin)
    DOCKER_OPTIONS += $(shell [ ! -z "$(SSH_AUTH_SOCK)" ] && echo -v $(SSH_AUTH_SOCK):$(SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$(SSH_AUTH_SOCK))
    DOCKER_OPTIONS += -v ~/.ssh/ovh:/root/.ssh/ovh
    DOCKER_OPTIONS += -v ~/.ssh/digital-ocean:/root/.ssh/digital-ocean
  else
    DOCKER_OPTIONS += -v ~/.ssh:/root/.ssh
  endif
  DOCKER_OPTIONS += -v ~/.vagrant.d/:/root/.vagrant.d/

  # make status
  DOCKER_OPTIONS += -v $(shell realpath $(CLI_MK_DIR)):/kubernetes/etc



  # customized config
  CONFIGURATION_PATH = $(shell realpath $(CLI_MK_DIR)/..)
  ifneq ("$(wildcard $(CLI_MK_DIR)/../../customized)","")
    CONFIGURATION_PATH = $(shell realpath $(CLI_MK_DIR)/../../customized)
  endif

  KUBECONFIG ?= /workspace/certificates/master/admin-kube-config
  DOCKER_OPTIONS += -e KUBECONFIG=$(KUBECONFIG)
  DOCKER_OPTIONS += -v $(CONFIGURATION_PATH)/certificates:/workspace/certificates

  ifdef NEED_ANSIBLE
    DOCKER_OPTIONS += -v $(CONFIGURATION_PATH)/kubernetes/addons/labeled-volumes:/workspace/addons/labeled-volumes
    DOCKER_OPTIONS += -v $(CONFIGURATION_PATH)/ansible.cfg:/workspace/ansible.cfg
    DOCKER_OPTIONS += -v $(CONFIGURATION_PATH)/files:/workspace/files
    DOCKER_OPTIONS += -v $(CONFIGURATION_PATH)/inventory:/workspace/inventory
    DOCKER_OPTIONS += -v $(CONFIGURATION_PATH)/group_vars:/workspace/group_vars
    DOCKER_OPTIONS += -v $(CONFIGURATION_PATH)/host_vars:/workspace/host_vars
  endif

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
