#!/usr/bin/env bats

load test_helper

@test "portscan on node1" {
  NODE=`grep -o '.*1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run diff tests/portscan/node1.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | grep -v -E "(3276[89]|327[7-9][0-9]|32[89][0-9]{2}|3[3-9][0-9]{3}|[45][0-9]{4}|60[0-8][0-9]{2}|609[0-8][0-9]|6099[0-9])" | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*" | tail -n +2 | sort -h)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node2" {
  NODE=`grep -o '.*2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run diff tests/portscan/node2.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | grep -v -E "(3276[89]|327[7-9][0-9]|32[89][0-9]{2}|3[3-9][0-9]{3}|[45][0-9]{4}|60[0-8][0-9]{2}|609[0-8][0-9]|6099[0-9])" | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*" | tail -n +2 | sort -h)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node3" {
  NODE=`grep -o '.*3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run diff tests/portscan/node3.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | grep -v -E "(3276[89]|327[7-9][0-9]|32[89][0-9]{2}|3[3-9][0-9]{3}|[45][0-9]{4}|60[0-8][0-9]{2}|609[0-8][0-9]|6099[0-9])" | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*" | tail -n +2 | sort -h)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "portscan on node4" {
  NODE=`grep -o '.*4 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run diff tests/portscan/node4.golden <(ansible -i inventory ${NODE} -m shell -a "netstat -lntu" | grep -v -E "(3276[89]|327[7-9][0-9]|32[89][0-9]{2}|3[3-9][0-9]{3}|[45][0-9]{4}|60[0-8][0-9]{2}|609[0-8][0-9]|6099[0-9])" | grep -v "udp        0      0 0.0.0.0:68              0.0.0.0:*" | tail -n +2 | sort -h)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}
