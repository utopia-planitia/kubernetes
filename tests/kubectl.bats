#!/usr/bin/env bats

@test "verify kubernetes version node1" {
  IP=`grep node1 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run kubectl --server=https://${IP}:6443/ version
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [[ "${lines[0]}" =~ ^Client\ Version:\ .* ]]
  [[ "${lines[1]}" =~ ^Server\ Version:\ .* ]]
}

@test "verify kubernetes version node2" {
  IP=`grep node2 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run kubectl --server=https://${IP}:6443/ version
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [[ "${lines[0]}" =~ ^Client\ Version:\ .* ]]
  [[ "${lines[1]}" =~ ^Server\ Version:\ .* ]]
}

@test "verify kubernetes version node3" {
  IP=`grep node3 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run kubectl --server=https://${IP}:6443/ version
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [[ "${lines[0]}" =~ ^Client\ Version:\ .* ]]
  [[ "${lines[1]}" =~ ^Server\ Version:\ .* ]]
}

@test "verify kubernetes version node4" {
  IP=`grep node4 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run kubectl --server=https://${IP}:6443/ version
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [[ "${lines[0]}" =~ ^Client\ Version:\ .* ]]
  [[ "${lines[1]}" =~ ^Server\ Version:\ .* ]]
}
