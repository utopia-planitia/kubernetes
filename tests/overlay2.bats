#!/usr/bin/env bats

@test "node1: check overlay2 storage driver" {
  result="$( ansible -i inventory node1 -m shell -a "docker info" | grep "Storage Driver: " )"
  [ "$result" == "Storage Driver: overlay2" ]
}
@test "node2: check overlay2 storage driver" {
  result="$( ansible -i inventory node2 -m shell -a "docker info" | grep "Storage Driver: " )"
  [ "$result" == "Storage Driver: overlay2" ]
}
@test "node3: check overlay2 storage driver" {
  result="$( ansible -i inventory node3 -m shell -a "docker info" | grep "Storage Driver: " )"
  [ "$result" == "Storage Driver: overlay2" ]
}
@test "node4: check overlay2 storage driver" {
  result="$( ansible -i inventory node4 -m shell -a "docker info" | grep "Storage Driver: " )"
  [ "$result" == "Storage Driver: overlay2" ]
}
