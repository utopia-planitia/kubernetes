#!/usr/bin/env bats

load test_helper

@test "portscan on node1" {
  NODE=`grep node1 inventory | grep ansible_host | awk '{print $1;}'`
  run diff tests/portscan/node1.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*" | tail -n +2 | sort -h)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node2" {
  NODE=`grep node2 inventory | grep ansible_host | awk '{print $1;}'`
  run diff tests/portscan/node2.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*" | tail -n +2 | sort -h)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node3" {
  NODE=`grep node3 inventory | grep ansible_host | awk '{print $1;}'`
  run diff tests/portscan/node3.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*" | tail -n +2 | sort -h)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node4" {
  NODE=`grep node4 inventory | grep ansible_host | awk '{print $1;}'`
  run diff tests/portscan/node4.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*" | tail -n +2 | sort -h)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}
