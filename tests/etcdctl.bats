#!/usr/bin/env bats

load test_helper

@test "verify etcdctl node1" {
  NODE=`grep -o '.*1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run kubectl -n kube-system exec etcd-$NODE -- etcdctl member list
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}

@test "verify etcdctl node2" {
  NODE=`grep -o '.*2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run kubectl -n kube-system exec etcd-$NODE -- etcdctl member list
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}

@test "verify etcdctl node3" {
  NODE=`grep -o '.*3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run kubectl -n kube-system exec etcd-$NODE -- etcdctl member list
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}
