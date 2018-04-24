#!/usr/bin/env bats

load test_helper

@test "search deprecated in logs of pod outputs" {
  # skip until kubernetes 1.10 and etcd 3.2
  # https://github.com/kubernetes/kubernetes/issues/56438
  # https://github.com/kubernetes-incubator/bootkube/issues/736
  skip
  run bash tests/deprecated/grep-logs.sh
  [ $status -eq 0 ]
}

@test "deprecations for kubelet on node1" {
  NODE=`grep node1 inventory | grep ansible_host | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a 'journaldctl --no-pager -b -u kubelet' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for docker on node1" {
  NODE=`grep node1 inventory | grep ansible_host | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a 'journaldctl --no-pager -b -u docker' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for kubelet on node2" {
  NODE=`grep node2 inventory | grep ansible_host | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a 'journaldctl --no-pager -b -u kubelet' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for docker on node2" {
  NODE=`grep node2 inventory | grep ansible_host | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a 'journaldctl --no-pager -b -u docker' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for kubelet on node3" {
  NODE=`grep node3 inventory | grep ansible_host | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a 'journaldctl --no-pager -b -u kubelet' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for docker on node3" {
  NODE=`grep node3 inventory | grep ansible_host | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a 'journaldctl --no-pager -b -u docker' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for kubelet on node4" {
  NODE=`grep node4 inventory | grep ansible_host | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a 'journaldctl --no-pager -b -u kubelet' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for docker on node4" {
  NODE=`grep node4 inventory | grep ansible_host | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a 'journaldctl --no-pager -b -u docker' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}