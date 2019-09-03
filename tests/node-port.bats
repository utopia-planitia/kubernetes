#!/usr/bin/env bats

load test_helper

@test "deploy nginx with node port service" {
  kubectl apply -f tests/node-port
  sleep 1
  run kubectl -n test-node-port wait pods -l app=nginx --for=condition=ready
  [ $status -eq 0 ]
}

@test "use node port" {
  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  PORT=`kubectl get svc -n test-node-port -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}'`
  run curl -v --connect-timeout 5 --max-time 5 --retry 12 --retry-delay 0 --retry-max-time 60 --retry-connrefused http://${IP}:${PORT}/
  [ $status -eq 0 ]
}

@test "undeploy nginx with node port service" {
  kubectl delete -f tests/node-port
  run sh -c "kubectl -n test-node-port wait pods -l app=nginx --for=delete || kubectl delete -f tests/node-port --ignore-not-found=true"
  [ $status -eq 0 ]
}
