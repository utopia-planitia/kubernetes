#!/usr/bin/env bats

@test "check transfer time" {
  kubectl apply -f tests/network-throughput
  until [ $(kubectl get pod transmit --no-headers | grep Running | grep 1/1 | wc -l) -eq 1 ]; do sleep 1; done
  until [ $(kubectl get pod receive --no-headers | grep Running | grep 1/1 | wc -l) -eq 1 ]; do sleep 1; done

  run kubectl exec transmit -- apk --update add curl
  [ $status -eq 0 ]

#  kubectl exec transmit -- dd if=/dev/urandom of=/file bs=1M count=100
  run kubectl exec transmit -- timeout -t 2 curl -o file --fail https://speed.hetzner.de/100MB.bin
  [ $status -eq 0 ]

  run kubectl exec transmit -- timeout -t 60 sh -c "until curl --fail --max-time 1 --connect-timeout 1 http://receive/; do sleep 1; done"
 
  run kubectl exec transmit -- timeout -t 2 curl -T file --fail http://receive/file # timeout -t 2 ensures at least 66,5MB/s
  [ $status -eq 0 ]
}

teardown () {
  kubectl delete -f tests/network-throughput --ignore-not-found=true
  until [ $(kubectl get pod transmit --no-headers | wc -l) -eq 0 ]; do sleep 1; done
  until [ $(kubectl get pod receive --no-headers | wc -l) -eq 0 ]; do sleep 1; done

# from "load test_helper"
  echo teardown log
  echo "exit code: $status"
  for i in "${!lines[@]}"; do 
    printf "line %s:\t%s\n" "$i" "${lines[$i]}"
  done
  echo teardown done
}
