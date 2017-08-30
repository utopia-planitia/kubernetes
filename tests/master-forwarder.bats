#!/usr/bin/env bats

@test "node1: wait for apiserver" {
  until [[ $( ansible -i inventory node1 -m shell -a "docker ps" | grep " k8s_apiserver_k8s-master" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for apiserver" {
  until [[ $( ansible -i inventory node2 -m shell -a "docker ps" | grep " k8s_apiserver_k8s-master" | wc -l ) = "1" ]]; do
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

@test "node1: check apiserver" {
  result="$( ansible -i inventory node1 -m raw -a "curl -k https://127.0.0.1:6443/ | grep Unauthorized")"
  [[ "$status" -eq 0 ]]
}
@test "node2: check apiserver" {
  result="$( ansible -i inventory node2 -m raw -a "curl -k https://127.0.0.1:6443/ | grep Unauthorized")"
  [[ "$status" -eq 0 ]]
}
@test "node3: check master-forwarder" {
  result="$( ansible -i inventory node3 -m raw -a "curl -k https://127.0.0.1:6443/ | grep Unauthorized")"
  [[ "$status" -eq 0 ]]
}
@test "node4: check master-forwarder" {
  result="$( ansible -i inventory node4 -m raw -a "curl -k https://127.0.0.1:6443/ | grep Unauthorized")"
  [[ "$status" -eq 0 ]]
}
