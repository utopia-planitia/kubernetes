#!/usr/bin/env bats

@test "node1: check kubelet" {
  result="$( ansible -i inventory node1 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}
@test "node2: check kubelet" {
  result="$( ansible -i inventory node2 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}
@test "node3: check kubelet" {
  result="$( ansible -i inventory node3 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}
@test "node4: check kubelet" {
  result="$( ansible -i inventory node4 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}

@test "node1: wait for apiserver" {
  until [[ $( ansible -i inventory node1 -m shell -a "docker ps" | grep " k8s_apiserver_master" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for apiserver" {
  until [[ $( ansible -i inventory node2 -m shell -a "docker ps" | grep " k8s_apiserver_master" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node3: wait for master-forwarder" {
  until [[ $( ansible -i inventory node3 -m shell -a "docker ps" | grep " k8s_forwarder_master-forwarder" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node4: wait for master-forwarder" {
  until [[ $( ansible -i inventory node4 -m shell -a "docker ps" | grep " k8s_forwarder_master-forwarder" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}

@test "node1: wait for registration" {  
  until [[ $( kubectl get no --no-headers=true | grep node1 | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for registration" {
  until [[ $( kubectl get no --no-headers=true | grep node2 | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node3: wait for registration" {
  until [[ $( kubectl get no --no-headers=true | grep node3 | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node4: wait for registration" {
  until [[ $( kubectl get no --no-headers=true | grep node4 | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
