#!/usr/bin/env bats

@test "use host port" {
  kubectl apply -f tests/host-port

  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  PORT=32123
  NODES_COUNT=$( grep ansible_host inventory | wc -l)
  until [ $(kubectl -n test-host-port -l app=nginx get pod --no-headers | grep Running | wc -l) == $NODES_COUNT ]; do sleep 1; done
  timeout 120 sh -c "until curl --fail http://${IP}:${PORT}/; do sleep 1; done"
  run curl --fail http://${IP}:${PORT}/
  [ $status -eq 0 ]
}

teardown () {
  kubectl delete -f tests/host-port --ignore-not-found=true
  until [ $(kubectl get ns --no-headers | grep test-host-port | wc -l) == 0 ]; do sleep 1; done

# from "load test_helper"
  echo teardown log
  echo "exit code: $status"
  for i in "${!lines[@]}"; do 
    printf "line %s:\t%s\n" "$i" "${lines[$i]}"
  done
  echo teardown done
}
