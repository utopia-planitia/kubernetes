
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
	$(MAKE) local-volumes

.PHONY: kubernetes
kubernetes: ##@ansible deploy kubernetes
	$(CLI) ansible-playbook kubernetes.yml $(ANSIBLE_OPTIONS)
	$(CLI) bash etc/wait-for-nodes.sh

.PHONY: addons
addons: ##@ansible deploy addons
	$(CLI) kubectl apply -f addons/kube-dns.yaml \
	                     -f addons/weave-daemonset.yaml \
	                     -f addons/registry-mirror.yaml \
	                     -f certificates/addons/
	$(CLI) bash etc/wait-for-addons.sh

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

.PHONY: status
status: ##@development show current system status
	@$(CLI) ./etc/status.sh
