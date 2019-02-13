#!/usr/bin/env bats

load test_helper

@test "deploy nginx with node port service" {
  run kubectl apply -f tests/node-port
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}

@test "use node port" {
  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  PORT=`kubectl get svc -n test-node-port -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}'`
  until [ $(kubectl -n test-node-port -l app=nginx get pod --no-headers | grep Running | wc -l) == 1 ]; do
    sleep 1
  done
  until [ $(kubectl -n test-node-port -l app=nginx get ep --no-headers | wc -l) == 1 ]; do
    sleep 1
  done
  until [ $(curl http://${IP}:${PORT}/ | grep "Welcome to nginx!" | wc -l ) == 2 ]; do
    sleep 1
  done
  run curl --fail http://${IP}:${PORT}/
  [ $status -eq 0 ]
}

@test "undeploy nginx with node port service" {
  run kubectl delete -f tests/node-port
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
  until [ $(kubectl get ns --no-headers | grep test-node-port | wc -l) == 0 ]; do
    sleep 1
  done
}
