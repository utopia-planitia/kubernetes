#!/usr/bin/env bats

load test_helper

# 0.0.0.0:68 is the dhcp client for ubuntu in vagrant

@test "portscan on node1" {
  NODE=`grep -o '.*1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run ansible -i inventory ${NODE} -m shell -a "netstat -ntpl" | tail -n +4 | sed 's/:::/0.0.0.0:/g' | sed 's/:/ /g' | sort | awk -f tests/port-scan/filter-out-verified.awk
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node2" {
  NODE=`grep -o '.*2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run ansible -i inventory ${NODE} -m shell -a "netstat -ntpl" | tail -n +4 | sed 's/:::/0.0.0.0:/g' | sed 's/:/ /g' | sort | awk -f tests/port-scan/filter-out-verified.awk
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node3" {
  NODE=`grep -o '.*3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run ansible -i inventory ${NODE} -m shell -a "netstat -ntpl" | tail -n +4 | sed 's/:::/0.0.0.0:/g' | sed 's/:/ /g' | sort | awk -f tests/port-scan/filter-out-verified.awk
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node4" {
  NODE=`grep -o '.*4 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run ansible -i inventory ${NODE} -m shell -a "netstat -ntpl" | tail -n +4 | sed 's/:::/0.0.0.0:/g' | sed 's/:/ /g' | sort | awk -f tests/port-scan/filter-out-verified.awk
  [ "${#lines[@]}" -eq 0 ]
}
