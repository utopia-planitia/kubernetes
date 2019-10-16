#!/usr/bin/env bats

@test "check ping to google-dns" {
  run kubectl apply -f tests/ping
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]

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

teardown () {
  kubectl delete -f tests/ping --ignore-not-found=true
  until [ $(kubectl get pod --selector=job-name=google-dns --no-headers | wc -l) -eq 0 ]; do sleep 1; done

# from "load test_helper"
  echo teardown log
  echo "exit code: $status"
  for i in "${!lines[@]}"; do 
    printf "line %s:\t%s\n" "$i" "${lines[$i]}"
  done
  echo teardown done
}
