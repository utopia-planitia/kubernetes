
.PHONY: lint
lint: ##@ansible lint ansible config
	$(CLI) ansible-lint *.yml roles

.PHONY: tests
tests: ##@tests run bats tests
	make bats

.PHONY: bats
bats: ##@tests run bats tests
	$(CLI) bats tests/

.PHONY: kube-tests
kube-tests: ##@tests run kubernetes e2e tests
	make conformance
	make port-forward
	make serial

.PHONY: conformance
conformance: ##@tests run conformance tests
	$(E2E) sh -c 'E2E_PARALLEL=y E2E_SKIP="Alpha|Kubectl|Serial|\[(Disruptive|Feature:[^\]]+|Flaky)\]" E2E_FOCUS="\[Conformance\]" /run_e2e.sh'

.PHONY: port-forward
port-forward: ##@tests run port-forward test
	$(E2E) sh -c 'E2E_PARALLEL=y E2E_SKIP="Alpha|\[(Disruptive|Feature:[^\]]+|Flaky)\]" E2E_FOCUS="port-forward" /run_e2e.sh'

.PHONY: serial
serial: ##@tests run serial test
	$(E2E) sh -c 'E2E_PARALLEL=n E2E_SKIP="Alpha|Kubectl|\[(Disruptive|Feature:[^\]]+|Flaky)\]" E2E_FOCUS="Serial.*Conformance" /run_e2e.sh'

.PHONY: delete-e2e-namespaces
delete-e2e-namespaces: ##@tests remove namespaces created by failed e2e tests
	$(CLI) ./etc/delete-e2e-namespaces.sh

PHONY: benchmark-nodes
benchmark-nodes: ##@tests ensure test vms provide enough performance
	$(CLI) ansible-playbook prepare-benchmarks.yml ${ANSIBLE_OPTIONS}
