
include ./etc/help.mk
include ./etc/cli.mk
include ./etc/tests.mk
include ./etc/ovh.mk
include ./etc/digital-ocean.mk
include ./etc/vagrant/vagrant.mk

.PHONY: system-requirements-check
system-requirements-check: ##@setup checks system for required dependencies
	./etc/system-requirements-check.sh

.PHONY: certificates
certificates:
	$(CLI) sh -c 'touch certificates && rm -r certificates'
	$(CLI) ansible-playbook certificates.yml ${ANSIBLE_OPTIONS}

.PHONY: deploy
deploy: ##@ansible deploy to nodes
	$(CLI) ansible-playbook deploy.yml       ${ANSIBLE_OPTIONS}
	$(CLI) bash etc/wait-for-nodes.sh
	$(CLI) kubectl apply  -R -f addons/ \
	                         -f certificates/addons/
	$(CLI) bash etc/wait-for-addons.sh
	$(CLI) kubectl -n kube-system delete job local-volume-provisioner-bootstrap

.PHONY: status
status: ##@development show current system status
	@$(CLI) ./etc/status.sh
