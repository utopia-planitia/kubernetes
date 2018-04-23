#!/usr/bin/env bats

load test_helper

@test "deploy ping jobs" {
  run kubectl apply -f tests/ping
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}

@test "check ping to google-dns" {
  until [ $(kubectl get pod -a --selector=job-name=google-dns --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=google-dns --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 5 ]
  [ "${lines[3]}" = "1 packets transmitted, 1 packets received, 0% packet loss" ]
}

@test "undeploy ping jobs" {
  run kubectl delete -f tests/ping
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}
