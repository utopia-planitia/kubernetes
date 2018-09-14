
IS_CONTAINERIZED =
ifneq ($(shell uname), Darwin)
  ifneq ($(shell cat /proc/1/cgroup | grep docker | wc -l), 0)
    IS_CONTAINERIZED = yes
  endif
  ifneq ($(shell cat /proc/1/cgroup | grep kubepods | wc -l), 0)
    IS_CONTAINERIZED = yes
  endif
endif

CLI =
ifndef IS_CONTAINERIZED
  KUBERNETES_TOOLS_IMAGE ?= $(shell docker build -q ../kubernetes/docker/dev-tools)
  KUBERNETES_E2E_IMAGE ?= $(shell docker build -q ../kubernetes/docker/e2e-tests)

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
  DOCKER_OPTIONS += -v $(shell realpath ../kubernetes/etc):/kubernetes/etc



  # customized config
  ANSIBLE_PATH = $(shell realpath ../kubernetes)
  ifneq ("$(wildcard ../customized)","")
    ANSIBLE_PATH = $(shell realpath ../customized)
  endif

  KUBECONFIG ?= /workspace/certificates/master/admin-kube-config
  DOCKER_OPTIONS += -e KUBECONFIG=$(KUBECONFIG)

  ifdef NEED_ANSIBLE
    DOCKER_OPTIONS += -v $(ANSIBLE_PATH)/certificates:/workspace/certificates
    DOCKER_OPTIONS += -v $(ANSIBLE_PATH)/ansible.cfg:/workspace/ansible.cfg
    DOCKER_OPTIONS += -v $(ANSIBLE_PATH)/files:/workspace/files
    DOCKER_OPTIONS += -v $(ANSIBLE_PATH)/inventory:/workspace/inventory
    DOCKER_OPTIONS += -v $(ANSIBLE_PATH)/group_vars:/workspace/group_vars
    DOCKER_OPTIONS += -v $(ANSIBLE_PATH)/host_vars:/workspace/host_vars
  endif

  CLI = $(DOCKER) run --net=host --rm -ti $(DOCKER_OPTIONS) $(KUBERNETES_TOOLS_IMAGE)
  E2E = $(DOCKER) run --net=host --rm -ti $(DOCKER_OPTIONS) $(KUBERNETES_E2E_IMAGE)
endif

.PHONY: cli
cli: ##@development creates admin command line interface
	$(CLI) bash

.PHONY: e2e-cli
e2e-cli: ##@development creates end to end testing command line interface
	$(E2E) bash

.PHONY: demo-cli
demo-cli: ##@development creates user command line interface
	$(CLI) sh -c "KUBECONFIG=/workspace/certificates/user/demo-user-kube-config bash"
