#!/usr/bin/env bats

@test "check google-public-dns-a-google-com ip" {
  kubectl apply -f tests/dns/google-public-dns-a.google.com.yml
  until [ $(kubectl get pod --selector=job-name=google-public-dns-a-google-com --no-headers | grep Completed | wc -l) -eq 1 ]; do sleep 1; done
  run kubectl logs `kubectl get pod -l=job-name=google-public-dns-a-google-com --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 8.8.8.8" ]
}

@test "check node-local-dns ip" {
  kubectl apply -f tests/dns/node-local-dns-ip.yml
  until [ $(kubectl get pod --selector=job-name=node-local-dns-ip --no-headers | grep Completed | wc -l) -eq 1 ]; do sleep 1; done
  run kubectl logs `kubectl get pod --selector=job-name=node-local-dns-ip --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${lines[0]}" = "Address:	169.254.20.10#53" ]
}

@test "check kubernetes-default-svc-cluster-local ip" {
  kubectl apply -f tests/dns/kubernetes.default.svc.cluster.local.yml
  until [ $(kubectl get pod --selector=job-name=kubernetes-default-svc-cluster-local --no-headers | grep Completed | wc -l) -eq 1 ]; do sleep 1; done
  run kubectl logs `kubectl get pod --selector=job-name=kubernetes-default-svc-cluster-local --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.1" ]
}

@test "check kubernetes-default-svc ip" {
  kubectl apply -f tests/dns/kubernetes.default.svc.yml
  until [ $(kubectl get pod --selector=job-name=kubernetes-default-svc --no-headers | grep Completed | wc -l) -eq 1 ]; do sleep 1; done
  run kubectl logs `kubectl get pod --selector=job-name=kubernetes-default-svc --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.1" ]
}

@test "check kubernetes-default ip" {
  kubectl apply -f tests/dns/kubernetes.default.yml
  until [ $(kubectl get pod --selector=job-name=kubernetes-default --no-headers | grep Completed | wc -l) -eq 1 ]; do sleep 1; done
  run kubectl logs `kubectl get pod --selector=job-name=kubernetes-default --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.1" ]
}

@test "check kubernetes ip" {
  kubectl apply -f tests/dns/kubernetes.yml
  until [ $(kubectl get pod --selector=job-name=kubernetes --no-headers | grep Completed | wc -l) -eq 1 ]; do sleep 1; done
  run kubectl logs `kubectl get pod --selector=job-name=kubernetes --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.1" ]
}

teardown () {
  kubectl delete -f tests/dns --ignore-not-found=true

# from "load test_helper"
  echo teardown log
  echo "exit code: $status"
  for i in "${!lines[@]}"; do 
    printf "line %s:\t%s\n" "$i" "${lines[$i]}"
  done
  echo teardown done
}
