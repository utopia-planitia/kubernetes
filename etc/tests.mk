
.PHONY: lint
lint: ##@ansible lint ansible config
	$(CLI) ansible-lint *.yml roles

.PHONY: tests
tests: ##@development run all tests
	$(MAKE) bats
	$(MAKE) e2e-conformance
	$(MAKE) e2e-port-forward

.PHONY: bats
bats: ##@development run bats tests
	$(CLI) bats tests/

.PHONY: e2e-conformance
e2e-conformance: ##@development run e2e-conformance tests
	$(CLI) sh -c 'cd /go/src/k8s.io/kubernetes && go run hack/e2e.go -get=false -- -v -test -check-version-skew=false --provider=skeleton -test_args="--ginkgo.focus=\[Conformance\] --ginkgo.skip=\[Serial\]|\[Flaky\]|\[Feature:.+\]" --ginkgo-parallel'
	$(CLI) sh -c 'cd /go/src/k8s.io/kubernetes && go run hack/e2e.go -get=false -- -v -test -check-version-skew=false --provider=skeleton -test_args="--ginkgo.focus=\[Serial\].*\[Conformance\]"'

.PHONY: e2e-port-forward
e2e-port-forward: ##@development run e2e-port-forward test
	$(CLI) sh -c 'cd /go/src/k8s.io/kubernetes && go run hack/e2e.go -get=false -- -v -test -check-version-skew=false --provider=skeleton -test_args="--ginkgo.focus=port-forward"'