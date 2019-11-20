
DOCKER_OPTIONS += -v $(KUBERNETES_CONFIG_PATH)/certificates:/workspace/certificates

include ./etc/help.mk
include ./etc/cli.mk
include ./etc/tests.mk
include ./etc/ovh.mk
include ./etc/digital-ocean.mk
include ./etc/vagrant/vagrant.mk

.PHONY: certificates
certificates: ##@ansible delete and recreate cluster secrets
	$(CLI) ansible-playbook certificates.yml $(ANSIBLE_OPTIONS)
	$(CLI) make certificates/cilium-secret.yaml

certificates/cilium-secret.yaml:
	kubectl create -n kube-system secret generic cilium-ipsec-keys \
		--from-literal=keys="3 rfc4106(gcm(aes)) $(shell dd if=/dev/urandom count=20 bs=1 2> /dev/null| xxd -p -c 64) 128" \
		-o yaml --dry-run=true \
		> certificates/cilium-secret.yaml

.PHONY: deploy
deploy: ##@ansible setup cluster
	make kubernetes
	make addons

.PHONY: kubernetes
kubernetes: ##@ansible deploy kubernetes
	$(CLI) ansible-playbook kubernetes.yml $(ANSIBLE_OPTIONS)
	$(CLI) bash etc/wait-for-nodes.sh

.PHONY: addons
addons: ##@ansible deploy addons
	$(CLI) kubectl apply -f addons/core-dns.yaml \
	                     -f addons/nodelocaldns.yaml \
	                     -f certificates/cilium-secret.yaml \
	                     -f addons/cilium.yaml \
	                     -f addons/registry-mirror.yaml
	$(CLI) bash etc/wait-for-addons.sh

.PHONY: restart
restart: ##@ansible restart kubelet & docker
	$(CLI) ansible-playbook restart-services.yml $(ANSIBLE_OPTIONS)
