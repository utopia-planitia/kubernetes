#!/usr/bin/env bats

load test_helper

@test "verify etcdctl node1" {
  NODE=`grep node1 inventory | grep -v ansible_host | head -n 1`
  run kubectl -n kube-system exec etcd-$NODE -- etcdctl member list
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}

@test "verify etcdctl node2" {
  NODE=`grep node2 inventory | grep -v ansible_host | head -n 1`
  run kubectl -n kube-system exec etcd-$NODE -- etcdctl member list
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}

@test "verify etcdctl node3" {
  NODE=`grep node3 inventory | grep -v ansible_host | head -n 1`
  run kubectl -n kube-system exec etcd-$NODE -- etcdctl member list
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}
