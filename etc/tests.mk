
.PHONY: lint
lint: ##@ansible lint ansible config
	$(CLI) ansible-lint *.yml roles

.PHONY: tests
tests: ##@development run all tests
	$(MAKE) bats
	$(MAKE) conformance
	$(MAKE) port-forward
	$(MAKE) serial

.PHONY: bats
bats: ##@development run bats tests
	$(CLI) bats tests/

.PHONY: conformance
conformance: ##@development run conformance tests
	$(E2E) sh -c 'E2E_PARALLEL=y E2E_SKIP="Alpha|Kubectl|Serial|\[(Disruptive|Feature:[^\]]+|Flaky)\]" E2E_FOCUS="\[Conformance\]" /run_e2e.sh'

.PHONY: port-forward
port-forward: ##@development run port-forward test
	$(E2E) sh -c 'E2E_PARALLEL=y E2E_SKIP="Alpha|\[(Disruptive|Feature:[^\]]+|Flaky)\]" E2E_FOCUS="port-forward" /run_e2e.sh'

.PHONY: serial
serial: ##@development run serial test
	$(E2E) sh -c 'E2E_PARALLEL=n E2E_SKIP="Alpha|Kubectl|\[(Disruptive|Feature:[^\]]+|Flaky)\]" E2E_FOCUS="Serial.*Conformance" /run_e2e.sh'

.PHONY: delete-e2e-namespaces
delete-e2e-namespaces: ##@development remove namespaces created by failed e2e tests
	$(CLI) ./etc/delete-e2e-namespaces.sh

PHONY: benchmark-nodes
benchmark-nodes: ##@development ensure test vms provide enough performance
	$(CLI) ansible-playbook prepare-benchmarks.yml ${ANSIBLE_OPTIONS}
