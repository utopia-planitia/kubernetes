
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
	$(CLI) sh -c 'cd /go/src/k8s.io/kubernetes && go run hack/e2e.go -get=false -- -v --test --check-version-skew=false --provider=skeleton --test_args="--ginkgo.focus=\[Conformance\] --ginkgo.skip=\[Serial\]|\[Flaky\]|\[Feature:.+\]" --ginkgo-parallel'

.PHONY: port-forward
port-forward: ##@development run port-forward test
	$(CLI) sh -c 'cd /go/src/k8s.io/kubernetes && go run hack/e2e.go -get=false -- -v --test --check-version-skew=false --provider=skeleton --test_args="--ginkgo.focus=port-forward"'

.PHONY: serial
serial: ##@development run serial test
	$(CLI) sh -c 'cd /go/src/k8s.io/kubernetes && go run hack/e2e.go -get=false -- -v --test --check-version-skew=false --provider=skeleton --test_args="--ginkgo.focus=\[Serial\].*\[Conformance\]"'

.PHONY: delete-e2e-namespaces
delete-e2e-namespaces: ##@development remove namespaces created by failed e2e tests
	$(CLI) ./etc/delete-e2e-namespaces.sh

