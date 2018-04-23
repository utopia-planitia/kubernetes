#!/usr/bin/env bats

load test_helper

@test "deploy dns jobs" {
  run kubectl apply -f tests/kube-dns
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 8 ]
}

@test "check google-public-dns-a-google-com ip" {
  until [ $(kubectl get pod -a --selector=job-name=google-public-dns-a-google-com --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a -l=job-name=google-public-dns-a-google-com --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 8.8.8.8" ]
}

@test "check kube-dns-kube-system-svc-cluster-local ip" {
  until [ $(kubectl get pod -a --selector=job-name=kube-dns-kube-system-svc-cluster-local --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=kube-dns-kube-system-svc-cluster-local --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.3" ]
}

@test "check kube-dns-kube-system-svc ip" {
  until [ $(kubectl get pod -a --selector=job-name=kube-dns-kube-system-svc --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=kube-dns-kube-system-svc --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.3" ]
}

@test "check kube-dns-kube-system ip" {
  until [ $(kubectl get pod -a --selector=job-name=kube-dns-kube-system --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=kube-dns-kube-system --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.3" ]
}

@test "check kubernetes-default-svc-cluster-local ip" {
  until [ $(kubectl get pod -a --selector=job-name=kubernetes-default-svc-cluster-local --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=kubernetes-default-svc-cluster-local --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.1" ]
}

@test "check kubernetes-default-svc ip" {
  until [ $(kubectl get pod -a --selector=job-name=kubernetes-default-svc --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=kubernetes-default-svc --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.1" ]
}

@test "check kubernetes-default ip" {
  until [ $(kubectl get pod -a --selector=job-name=kubernetes-default --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=kubernetes-default --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.1" ]
}

@test "check kubernetes ip" {
  until [ $(kubectl get pod -a --selector=job-name=kubernetes --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=kubernetes --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = "Address: 10.16.0.1" ]
}

@test "undeploy dns jobs" {
  run kubectl delete -f tests/kube-dns
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 8 ]
}
