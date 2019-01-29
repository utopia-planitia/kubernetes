
DOCKER_OPTIONS += -v $(KUBERNETES_CONFIG_PATH)/certificates:/workspace/certificates

include ./etc/help.mk
include ./etc/cli.mk
include ./etc/tests.mk
include ./etc/update.mk
include ./etc/ovh.mk
include ./etc/digital-ocean.mk
include ./etc/vagrant/vagrant.mk

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

.PHONY: kubernetes
kubernetes: ##@ansible deploy kubernetes
	$(CLI) ansible-playbook kubernetes.yml $(ANSIBLE_OPTIONS)
	$(CLI) bash etc/wait-for-nodes.sh

.PHONY: addons
addons: ##@ansible deploy addons
	$(CLI) kubectl apply -f addons/core-dns.yaml \
	                     -f addons/registry-mirror.yaml \
	                     -f addons/metrics-server/
	$(CLI) bash etc/wait-for-addons.sh
	$(CLI) kubectl -n kube-system delete svc kube-dns --ignore-not-found=true

.PHONY: restart
restart: ##@ansible restart kubelet & docker
	$(CLI) ansible-playbook restart-services.yml $(ANSIBLE_OPTIONS)
