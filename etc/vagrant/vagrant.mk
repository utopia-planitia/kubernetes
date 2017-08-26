export VAGRANT_OS ?= bento-16.04

.PHONY: vagrant-update-box
vagrant-update-box: ##@vagrant download current base box image
	vagrant box update

.PHONY: vagrant-start
vagrant-start: ##@vagrant start vms
	./etc/vagrant/up.sh

.PHONY: vagrant-stop
vagrant-stop: ##@vagrant stop vms
	./etc/vagrant/halt.sh

.PHONY: vagrant-destroy
vagrant-destroy: ##@vagrant stop and remove vms
	./etc/vagrant/destroy.sh

.PHONY: vagrant-provision
vagrant-provision: ##@vagrant start vms and create inventory
	$(MAKE) vagrant-start
	unlink ./inventory
	cp ./etc/vagrant/inventory-${VAGRANT_OS} ./inventory