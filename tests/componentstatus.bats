#!/usr/bin/env bats

load test_helper

@test "verify componentstatus node1" {
  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run sh -c "kubectl --server=https://${IP}:6443/ get componentstatus --no-headers=true | sort"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 5 ]
  [ "${lines[0]}" = 'controller-manager   Healthy   ok                   ' ]
  [ "${lines[1]}" = 'etcd-0               Healthy   {"health": "true"}   ' ]
  [ "${lines[2]}" = 'etcd-1               Healthy   {"health": "true"}   ' ]
  [ "${lines[3]}" = 'etcd-2               Healthy   {"health": "true"}   ' ]
  [ "${lines[4]}" = 'scheduler            Healthy   ok                   ' ]
}

@test "verify componentstatus node2" {
  IP=`grep -o '2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run sh -c "kubectl --server=https://${IP}:6443/ get componentstatus --no-headers=true | sort"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 5 ]
  [ "${lines[0]}" = 'controller-manager   Healthy   ok                   ' ]
  [ "${lines[1]}" = 'etcd-0               Healthy   {"health": "true"}   ' ]
  [ "${lines[2]}" = 'etcd-1               Healthy   {"health": "true"}   ' ]
  [ "${lines[3]}" = 'etcd-2               Healthy   {"health": "true"}   ' ]
  [ "${lines[4]}" = 'scheduler            Healthy   ok                   ' ]
}
