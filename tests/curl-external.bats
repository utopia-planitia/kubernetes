#!/usr/bin/env bats

load test_helper

@test "deploy curl-external jobs" {
  run kubectl apply -f tests/curl-external
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}

@test "check curl the weather" {
  until [ $(kubectl get pod --selector=job-name=wttr --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod --selector=job-name=wttr --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[1]}" = "│            Morning           │             Noon      └──────┬──────┘     Evening           │             Night            │" ]
}

@test "undeploy curl-external jobs" {
  run kubectl delete -f tests/curl-external
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}
