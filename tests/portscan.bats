#!/usr/bin/env bats

load test_helper

# 0.0.0.0:68 is the dhcp client for ubuntu in vagrant

@test "portscan on node1" {
  NODE=`grep -o '.*1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run diff tests/portscan/node1.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu -4" | grep -v ${NODE} | tail -n +1 | sort -h | grep -v 192.168.0.3 | grep -v 127.0.0.1 | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*")
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node2" {
  NODE=`grep -o '.*2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run diff tests/portscan/node2.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu -4" | grep -v ${NODE} | tail -n +1 | sort -h | grep -v 192.168.0.3 | grep -v 127.0.0.1 | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*")
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node3" {
  NODE=`grep -o '.*3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run diff tests/portscan/node3.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu -4" | grep -v ${NODE} | tail -n +1 | sort -h | grep -v 192.168.0.3 | grep -v 127.0.0.1 | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*")
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node4" {
  NODE=`grep -o '.*4 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run diff tests/portscan/node4.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu -4" | grep -v ${NODE} | tail -n +1 | sort -h | grep -v 192.168.0.3 | grep -v 127.0.0.1 | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*")
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}
