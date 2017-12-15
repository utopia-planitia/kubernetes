

CLI =
ifeq ($(shell cat /proc/1/cgroup | grep docker | wc -l), 0)
  KUBERNETES_TOOLS_IMAGE = $(shell docker build -q ../kubernetes/dev-tools)
  KUBERNETES_CERTIFICATES ?= $(shell realpath ../kubernetes/certificates)
  KUBERNETES_ETC ?= $(shell realpath ../kubernetes/etc)
  DOCKER = docker
  DOCKER_OPTIONS += -v $(PWD):/workspace -w /workspace
  DOCKER_OPTIONS += $(shell [ ! -z "$(SSH_AUTH_SOCK)" ] && echo -v $(SSH_AUTH_SOCK):$(SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$(SSH_AUTH_SOCK))
  DOCKER_OPTIONS += -v ~/.ssh/ovh:/root/.ssh/ovh
  DOCKER_OPTIONS += -v ~/.vagrant.d/:/root/.vagrant.d/
  DOCKER_OPTIONS += -v $(KUBERNETES_CERTIFICATES):/kubernetes/certificates -e KUBECONFIG=/kubernetes/certificates/master/admin-kube-config
  DOCKER_OPTIONS += -v $(KUBERNETES_ETC):/kubernetes/etc
  CLI = $(DOCKER) run --net=host --rm -ti $(DOCKER_OPTIONS) $(KUBERNETES_TOOLS_IMAGE)
endif

.PHONY: cli
cli: ##@development creates admin command line interface
	$(CLI)

.PHONY: demo-cli
demo-cli: ##@development creates user command line interface
	$(CLI) sh -c "KUBECONFIG=/workspace/certificates/user/demo-user-kube-config bash"
