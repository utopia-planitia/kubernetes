#!/usr/bin/env bats

load test_helper

@test "deploy logging jobs" {
  run kubectl apply -f tests/logging
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}

@test "check logging hello, world" {
  until [ $(kubectl get pod -a --selector=job-name=hello-world --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=hello-world --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = "Hello, World." ]
}

@test "undeploy logging jobs" {
  run kubectl delete -f tests/logging
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}
