#!/usr/bin/env bats

@test "check logging hello, world" {
  kubectl apply -f tests/logging
  until [ $(kubectl get pod --selector=job-name=hello-world --no-headers | grep Completed | wc -l) -eq 1 ]; do sleep 1; done

  run kubectl logs `kubectl get pod --selector=job-name=hello-world --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = "Hello, World." ]
}

teardown () {
  kubectl delete -f tests/logging --ignore-not-found=true

# from "load test_helper"
  echo teardown log
  echo "exit code: $status"
  for i in "${!lines[@]}"; do 
    printf "line %s:\t%s\n" "$i" "${lines[$i]}"
  done
  echo teardown done
}
