#!/usr/bin/env bats

@test "deploy anonymous-request job" {
  run kubectl apply -f tests/anonymous-request
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}

@test "check anonymous request to apiserver" {
  until [ $(kubectl get pod -a --selector=job-name=anonymous-request --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run kubectl logs `kubectl get pod -a --selector=job-name=anonymous-request --output=jsonpath={.items..metadata.name}`
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'Unauthorized' ]
}

@test "undeploy anonymous-request job" {
  run kubectl delete -f tests/anonymous-request
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}

@test "check anonymous request to apiserver on node1" {
  IP=`grep node1 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl  --silent --insecure https://${IP}:6443/
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'Unauthorized' ]
}

@test "check anonymous request to apiserver on node2" {
  IP=`grep node2 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl  --silent --insecure https://${IP}:6443/
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'Unauthorized' ]
}

@test "check anonymous request to apiserver on local https node1" {
  run ansible -i inventory node1 -m shell -a "curl  --silent --insecure https://127.0.0.1:6443/"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[2]}" = 'Unauthorized' ]
}

@test "check anonymous request to apiserver on local https node2" {
  run ansible -i inventory node2 -m shell -a "curl  --silent --insecure https://127.0.0.1:6443/"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[2]}" = 'Unauthorized' ]
}

@test "check anonymous request to etcd client node1" {
  IP=`grep node1 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k https://${IP}:2379/
  [ "$status" -eq 35 ]
}

@test "check anonymous request to etcd server node1" {
  IP=`grep node1 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k https://${IP}:2380/
  [ "$status" -eq 35 ]
}

@test "check anonymous request to etcd client node2" {
  IP=`grep node2 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k https://${IP}:2379/
  [ "$status" -eq 35 ]
}

@test "check anonymous request to etcd server node2" {
  IP=`grep node2 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k https://${IP}:2380/
  [ "$status" -eq 35 ]
}

@test "check anonymous request to etcd client node3" {
  IP=`grep node3 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k https://${IP}:2379/
  [ "$status" -eq 35 ]
}

@test "check anonymous request to etcd server node3" {
  IP=`grep node3 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k https://${IP}:2380/
  [ "$status" -eq 35 ]
}

@test "check anonymous request to kubelet on node1" {
  IP=`grep node1 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl  --silent --insecure https://${IP}:10250/metrics
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'Unauthorized' ]
}

@test "check anonymous request to kubelet on node2" {
  IP=`grep node2 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl  --silent --insecure https://${IP}:10250/metrics
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'Unauthorized' ]
}

@test "check anonymous request to kubelet on node3" {
  IP=`grep node3 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl  --silent --insecure https://${IP}:10250/metrics
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'Unauthorized' ]
}

@test "check anonymous request to kubelet on node4" {
  IP=`grep node4 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl  --silent --insecure https://${IP}:10250/metrics
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'Unauthorized' ]
}
