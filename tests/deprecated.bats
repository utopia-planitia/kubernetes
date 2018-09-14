#!/usr/bin/env bats

load test_helper

@test "search deprecated in logs of pod outputs" {
  # TODO
  skip "until scheduler uses --config"
  run bash tests/deprecated/grep-logs.sh
  [ $status -eq 0 ]
}

@test "deprecations for kubelet on node1" {
  # TODO
  skip "until --allow-privileged got removed"
  NODE=`grep -o '.*1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a ' journalctl --no-pager -b -u kubelet' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for docker on node1" {
  NODE=`grep -o '.*1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a ' journalctl --no-pager -b -u docker' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for kubelet on node2" {
  # TODO
  skip "until --allow-privileged got removed"
  NODE=`grep -o '.*2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a ' journalctl --no-pager -b -u kubelet' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for docker on node2" {
  NODE=`grep -o '.*2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a ' journalctl --no-pager -b -u docker' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for kubelet on node3" {
  # TODO
  skip "until --allow-privileged got removed"
  NODE=`grep -o '.*3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a ' journalctl --no-pager -b -u kubelet' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for docker on node3" {
  NODE=`grep -o '.*3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a ' journalctl --no-pager -b -u docker' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for kubelet on node4" {
  # TODO
  skip "until --allow-privileged got removed"
  NODE=`grep -o '.*4 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a ' journalctl --no-pager -b -u kubelet' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}

@test "deprecations for docker on node4" {
  NODE=`grep -o '.*4 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run sh -c "ansible -i inventory ${NODE} -m shell -a ' journalctl --no-pager -b -u docker' | grep -i deprecated"
  [ "${#lines[@]}" -eq 0 ]
}