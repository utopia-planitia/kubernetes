#!/usr/bin/env bats

load test_helper

@test "verify kubernetes version node1" {
  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run kubectl --server=https://${IP}:6443/ version
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [[ "${lines[0]}" =~ ^Client\ Version:\ .* ]]
  [[ "${lines[1]}" =~ ^Server\ Version:\ .* ]]
}

@test "verify kubernetes version node2" {
  IP=`grep -o '2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run kubectl --server=https://${IP}:6443/ version
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [[ "${lines[0]}" =~ ^Client\ Version:\ .* ]]
  [[ "${lines[1]}" =~ ^Server\ Version:\ .* ]]
}

@test "verify kubernetes version node3" {
  IP=`grep -o '3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run kubectl --server=https://${IP}:6443/ version
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [[ "${lines[0]}" =~ ^Client\ Version:\ .* ]]
  [[ "${lines[1]}" =~ ^Server\ Version:\ .* ]]
}

@test "verify kubernetes version node4" {
  IP=`grep -o '4 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run kubectl --server=https://${IP}:6443/ version
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [[ "${lines[0]}" =~ ^Client\ Version:\ .* ]]
  [[ "${lines[1]}" =~ ^Server\ Version:\ .* ]]
}
