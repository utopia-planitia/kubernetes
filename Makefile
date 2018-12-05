
DOCKER_OPTIONS += -v $(KUBERNETES_CONFIG_PATH)/certificates:/workspace/certificates
DOCKER_OPTIONS += -v $(KUBERNETES_CONFIG_PATH)/addons/labeled-volumes:/workspace/addons/labeled-volumes

include ./etc/help.mk
include ./etc/cli.mk
include ./etc/tests.mk
include ./etc/update.mk
include ./etc/ovh.mk
include ./etc/digital-ocean.mk
include ./etc/vagrant/vagrant.mk
include ./etc/hetzner-cloud.mk

.PHONY: system-requirements-check
system-requirements-check: ##@setup checks system for required dependencies
	./etc/system-requirements-check.sh

.PHONY: certificates
certificates: ##@ansible delete and recreate cluster secrets
	$(CLI) ansible-playbook certificates.yml $(ANSIBLE_OPTIONS)

.PHONY: deploy
deploy: ##@ansible setup cluster
	$(MAKE) kubernetes
	$(MAKE) addons
	$(MAKE) local-volumes

.PHONY: kubernetes
kubernetes: ##@ansible deploy kubernetes
	$(CLI) ansible-playbook kubernetes.yml $(ANSIBLE_OPTIONS)
	$(CLI) bash etc/wait-for-nodes.sh

.PHONY: addons
addons: ##@ansible deploy addons
	$(CLI) kubectl apply -f addons/core-dns.yaml \
	                     -f addons/weave-daemonset-k8s.yaml \
	                     -f addons/registry-mirror.yaml \
	                     -f addons/local-storage-class.yaml \
	                     -f addons/local-storage-class-dedicated.yaml \
	                     -f certificates/addons/
	$(CLI) bash etc/wait-for-addons.sh
	$(CLI) kubectl -n kube-system delete svc kube-dns --ignore-not-found=true

.PHONY: local-volumes
local-volumes: ##@ansible create local volumes
	$(CLI) kubectl -n kube-system delete --ignore-not-found=true --timeout=60s ds local-volume-provisioner
	$(CLI) kubectl -n kube-system delete --ignore-not-found=true --timeout=60s job local-volume-provisioner-bootstrap
	$(CLI) ansible-playbook local-volumes.yml $(ANSIBLE_OPTIONS)
	$(CLI) kubectl apply -f addons/labeled-volumes \
	                     -f addons/local-volume-provisioner.yaml
	$(CLI) bash etc/wait-for-local-volume-provisioner.sh
	$(CLI) kubectl -n kube-system delete --ignore-not-found=true --timeout=60s job local-volume-provisioner-bootstrap

.PHONY: restart
restart: ##@ansible restart kubelet & docker
	$(CLI) ansible-playbook restart-services.yml $(ANSIBLE_OPTIONS)
