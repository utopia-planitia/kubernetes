#!/usr/bin/env bats

load test_helper

@test "deploy ping jobs" {
  run kubectl apply -f tests/ping
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}

@test "check ping to google-dns" {
  until [ $(kubectl get pod --selector=job-name=google-dns --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 1
  done
  run bash -c "kubectl get pod --selector=job-name=google-dns --no-headers | grep Error | wc -l"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = "0" ]

  run kubectl logs `kubectl get pod --selector=job-name=google-dns --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 5 ]
  [ "${lines[3]}" = "1 packets transmitted, 1 packets received, 0% packet loss" ]
}

@test "undeploy ping jobs" {
  run kubectl delete -f tests/ping
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  until [ $(kubectl get pod --selector=job-name=google-dns --no-headers | wc -l) -eq 0 ]; do
    sleep 1
  done
}
