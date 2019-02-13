#!/usr/bin/env bats

load test_helper

@test "deploy nginx with host port" {
  run kubectl apply -f tests/host-port
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
}

@test "use host port" {
  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  PORT=32123
  NODES_COUNT=$( grep ansible_host inventory | wc -l)
  until [ $(kubectl -n test-host-port -l app=nginx get pod --no-headers | grep Running | wc -l) == $NODES_COUNT ]; do
    sleep 1
  done
  until [ $(curl http://${IP}:${PORT}/ | grep "Welcome to nginx!" | wc -l ) == 2 ]; do
    sleep 1
  done
  run curl --fail http://${IP}:${PORT}/
  [ $status -eq 0 ]
}

@test "undeploy nginx with host port" {
  run kubectl delete -f tests/host-port
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  until [ $(kubectl get ns --no-headers | grep test-host-port | wc -l) == 0 ]; do
    sleep 1
  done
}
