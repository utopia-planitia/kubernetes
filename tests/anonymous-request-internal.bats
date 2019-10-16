#!/usr/bin/env bats

@test "check anonymous request to apiserver (pod network)" {
  kubectl apply -f tests/anonymous-request/pod.yml
  timeout 120 sh -c "until kubectl get pod --selector=job-name=anonymous-request-pod --no-headers | grep Completed; do sleep 1; done"
  run diff tests/anonymous-request/request.golden <(kubectl logs `kubectl get pod --selector=job-name=anonymous-request-pod --output=jsonpath={.items..metadata.name}`)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "check anonymous request to apiserver (host network)" {
  kubectl apply -f tests/anonymous-request/host.yml
  timeout 120 sh -c "until kubectl get pod --selector=job-name=anonymous-request-host --no-headers | grep Completed; do sleep 1; done"
  run diff tests/anonymous-request/request.golden <(kubectl logs `kubectl get pod --selector=job-name=anonymous-request-host --output=jsonpath={.items..metadata.name}`)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

teardown () {
  kubectl delete -f tests/anonymous-request/pod.yml -f tests/anonymous-request/host.yml --ignore-not-found=true

# from "load test_helper"
  echo teardown log
  echo "exit code: $status"
  for i in "${!lines[@]}"; do 
    printf "line %s:\t%s\n" "$i" "${lines[$i]}"
  done
  echo teardown done
}
