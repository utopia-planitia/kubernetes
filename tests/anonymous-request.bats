#!/usr/bin/env bats

@test "deploy anonymous-request job" {
  run kubectl apply -f tests/anonymous-request
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}

@test "check anonymous request to apiserver" {
  until [ $(kubectl get pod -a --selector=job-name=anonymous-request --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=anonymous-request --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'User "system:anonymous" cannot get path "/".' ]
}

@test "undeploy anonymous-request job" {
  run kubectl delete -f tests/anonymous-request
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}
