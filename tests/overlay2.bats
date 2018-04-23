#!/usr/bin/env bats

load test_helper

@test "check overlay2 storage driver" {
  run ansible -i inventory all -m shell -a "docker info | grep 'Storage Driver: overlay2'"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 8 ]
}
