#!/usr/bin/env bats

@test "deploy anonymous-request job" {
  run kubectl apply -f tests/anonymous-request/job.yml
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}

@test "check anonymous request to apiserver" {
  until [ $(kubectl get pod -a --selector=job-name=anonymous-request --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run diff tests/anonymous-request/request.golden <(kubectl logs `kubectl get pod -a --selector=job-name=anonymous-request --output=jsonpath={.items..metadata.name}`)
  printf '%s\n' "${lines[@]}"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "undeploy anonymous-request job" {
  run kubectl delete -f tests/anonymous-request/job.yml
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
}

@test "check anonymous request to apiserver on node1" {
  IP=`grep node1 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run diff tests/anonymous-request/request.golden <(curl  --silent --insecure https://${IP}:6443/)
  printf '%s\n' "${lines[@]}"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "check anonymous request to apiserver on node2" {
  IP=`grep node2 inventory | grep ansible_host | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run diff tests/anonymous-request/request.golden <(curl  --silent --insecure https://${IP}:6443/)
  printf '%s\n' "${lines[@]}"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "check anonymous request to apiserver on local https node1" {
  NODE=`grep node1 inventory | grep ansible_host | awk '{print $1;}'`
  run diff tests/anonymous-request/request-ansible.golden <(ansible -i inventory ${NODE} -m shell -a "curl  --silent --insecure https://127.0.0.1:6443/" | tail -n+2)
  printf '%s\n' "${lines[@]}"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "check anonymous request to apiserver on local https node2" {
  NODE=`grep node2 inventory | grep ansible_host | awk '{print $1;}'`
  run diff tests/anonymous-request/request-ansible.golden <(ansible -i inventory ${NODE} -m shell -a "curl  --silent --insecure https://127.0.0.1:6443/" | tail -n+2)
  printf '%s\n' "${lines[@]}"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
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
