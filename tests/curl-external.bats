#!/usr/bin/env bats

load test_helper

@test "curl a unicorn" {
  kubectl apply -f tests/curl-external

  until [ $(kubectl get pod --selector=job-name=unicorn --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod --selector=job-name=unicorn --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = "                      ==/   /O   O\==--" ]

  kubectl delete -f tests/curl-external
}
