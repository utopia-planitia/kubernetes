#!/usr/bin/env bats

@test "node1: check storage driver" {
  result="$( ansible -i inventory node1 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}
@test "node2: check storage driver" {
  result="$( ansible -i inventory node2 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}
@test "node3: check storage driver" {
  result="$( ansible -i inventory node3 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}
@test "node4: check storage driver" {
  result="$( ansible -i inventory node4 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}
