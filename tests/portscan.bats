#!/usr/bin/env bats

@test "portscan on node1" {
  NODE=`grep node1 inventory | grep ansible_host | awk '{print $1;}'`
  run diff tests/portscan/node1.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | tail -n +2)
  printf '%s\n' "${lines[@]}"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node2" {
  NODE=`grep node2 inventory | grep ansible_host | awk '{print $1;}'`
  run diff tests/portscan/node2.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | tail -n +2)
  printf '%s\n' "${lines[@]}"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node3" {
  NODE=`grep node3 inventory | grep ansible_host | awk '{print $1;}'`
  run diff tests/portscan/node3.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | tail -n +2)
  printf '%s\n' "${lines[@]}"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node4" {
  NODE=`grep node4 inventory | grep ansible_host | awk '{print $1;}'`
  run diff tests/portscan/node4.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | tail -n +2)
  printf '%s\n' "${lines[@]}"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}
