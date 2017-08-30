#!/usr/bin/env bats

@test "node1: wait for apiserver" {
  until [[ $( ansible -i inventory node1 -m shell -a "docker ps" | grep "/apiserver " | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for apiserver" {
  until [[ $( ansible -i inventory node2 -m shell -a "docker ps" | grep "/apiserver " | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node1: wait for scheduler" {
  until [[ $( ansible -i inventory node1 -m shell -a "docker ps" | grep "/scheduler " | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for scheduler" {
  until [[ $( ansible -i inventory node2 -m shell -a "docker ps" | grep "/scheduler " | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node1: wait for controller-manager" {
  until [[ $( ansible -i inventory node1 -m shell -a "docker ps" | grep "/controller-manager " | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for controller-manager" {
  until [[ $( ansible -i inventory node2 -m shell -a "docker ps" | grep "/controller-manager " | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}

@test "node1: check apiserver" {
  result="$( ansible -i inventory node1 -m raw -a "curl http://127.0.0.1:8080/healthz | grep ok")"
  [[ "$status" -eq 0 ]]
}
@test "node2: check apiserver" {
  result="$( ansible -i inventory node2 -m raw -a "curl http://127.0.0.1:8080/healthz | grep ok")"
  [[ "$status" -eq 0 ]]
}
@test "node1: check scheduler" {
  result="$( ansible -i inventory node1 -m raw -a "curl http://127.0.0.1:10251/healthz | grep ok")"
  [[ "$status" -eq 0 ]]
}
@test "node2: check scheduler" {
  result="$( ansible -i inventory node2 -m raw -a "curl http://127.0.0.1:10251/healthz | grep ok")"
  [[ "$status" -eq 0 ]]
}
@test "node1: check controller-manager" {
  result="$( ansible -i inventory node1 -m raw -a "curl http://127.0.0.1:10252/healthz | grep ok")"
  [[ "$status" -eq 0 ]]
}
@test "node2: check controller-manager" {
  result="$( ansible -i inventory node2 -m raw -a "curl http://127.0.0.1:10252/healthz | grep ok")"
  [[ "$status" -eq 0 ]]
}
