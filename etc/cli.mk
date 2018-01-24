

CLI =
IS_CONTAINERIZED =
ifneq ($(shell uname), Darwin)
  ifneq ($(shell cat /proc/1/cgroup | grep docker | wc -l), 0)
    IS_CONTAINERIZED = yes
  endif
  ifneq ($(shell cat /proc/1/cgroup | grep kubepods | wc -l), 0)
    IS_CONTAINERIZED = yes
  endif
endif


ifndef IS_CONTAINERIZED
  KUBERNETES_TOOLS_IMAGE = $(shell docker build -q ../kubernetes/dev-tools)
  DOCKER = docker
  DOCKER_OPTIONS += -v $(PWD):/workspace -w /workspace
  DOCKER_OPTIONS += $(shell [ ! -z "$(SSH_AUTH_SOCK)" ] && echo -v $(SSH_AUTH_SOCK):$(SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$(SSH_AUTH_SOCK))
  DOCKER_OPTIONS += -v ~/.ssh/ovh:/root/.ssh/ovh
  DOCKER_OPTIONS += -v ~/.vagrant.d/:/root/.vagrant.d/
  DOCKER_OPTIONS += -v $(shell realpath ../kubernetes)/certificates:/kubernetes/certificates
  DOCKER_OPTIONS += -e KUBECONFIG=/kubernetes/certificates/master/admin-kube-config
  DOCKER_OPTIONS += -v $(shell realpath ../kubernetes)/etc:/kubernetes/etc
  ifdef NEED_ANSIBLE
    DOCKER_OPTIONS += -v $(shell realpath ../kubernetes)/ansible.cfg:/workspace/ansible.cfg
    DOCKER_OPTIONS += -v $(shell realpath ../kubernetes)/inventory:/workspace/inventory
    DOCKER_OPTIONS += -v $(shell realpath ../kubernetes)/group_vars:/workspace/group_vars
    DOCKER_OPTIONS += -v $(shell realpath ../kubernetes)/host_vars:/workspace/host_vars
  endif
  CLI = $(DOCKER) run --net=host --rm -ti $(DOCKER_OPTIONS) $(KUBERNETES_TOOLS_IMAGE)
endif

.PHONY: cli
cli: ##@development creates admin command line interface
	$(CLI)

.PHONY: demo-cli
demo-cli: ##@development creates user command line interface
	$(CLI) sh -c "KUBECONFIG=/workspace/certificates/user/demo-user-kube-config bash"
