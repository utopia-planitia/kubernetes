#!/usr/bin/env bats

load test_helper

@test "deploy nginx with node port service" {
  run kubectl apply -f tests/node-port
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}

@test "verify kubernetes version node1" {
  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  PORT=`kubectl get svc -n nginx-test -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}'`
  until [ $(kubectl -n nginx-test -l app=nginx get pod --no-headers | grep Running | wc -l) == 1 ]; do
    sleep 1
  done
  until [ $(kubectl -n nginx-test -l app=nginx get ep --no-headers | wc -l) == 1 ]; do
    sleep 1
  done
  until [ $(curl http://${IP}:${PORT}/ | grep "Welcome to nginx!" | wc -l ) == 2 ]; do
    sleep 1
  done
  run curl --fail http://${IP}:${PORT}/
  [ $status -eq 0 ]
}

@test "verify kubernetes version node2" {
  IP=`grep -o '2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  PORT=`kubectl get svc -n nginx-test -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}'`
  run curl --fail http://${IP}:${PORT}/
  [ $status -eq 0 ]
}

@test "verify kubernetes version node3" {
  IP=`grep -o '3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  PORT=`kubectl get svc -n nginx-test -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}'`
  run curl --fail http://${IP}:${PORT}/
  [ $status -eq 0 ]
}

@test "verify kubernetes version node4" {
  IP=`grep -o '4 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  PORT=`kubectl get svc -n nginx-test -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}'`
  run curl --fail http://${IP}:${PORT}/
  [ $status -eq 0 ]
}

@test "undeploy nginx with node port service" {
  run kubectl delete -f tests/node-port
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
  until [ $(kubectl get ns --no-headers | grep nginx-test | wc -l) == 0 ]; do
    sleep 1
  done
}
