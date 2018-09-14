#!/usr/bin/env bats

load test_helper

@test "deploy anonymous-request jobs" {
  run kubectl apply -f tests/anonymous-request/jobs.yml
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
}

@test "check anonymous request to apiserver (pod network)" {
  until [ $(kubectl get pod --selector=job-name=anonymous-request-pod --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run diff tests/anonymous-request/request.golden <(kubectl logs `kubectl get pod --selector=job-name=anonymous-request-pod --output=jsonpath={.items..metadata.name}`)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "check anonymous request to apiserver (host network)" {
  until [ $(kubectl get pod --selector=job-name=anonymous-request-host --no-headers | grep Completed | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  run diff tests/anonymous-request/request.golden <(kubectl logs `kubectl get pod --selector=job-name=anonymous-request-host --output=jsonpath={.items..metadata.name}`)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "undeploy anonymous-request jobs" {
  run kubectl delete -f tests/anonymous-request/jobs.yml
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
}

@test "check anonymous request to apiserver on node1" {
  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run diff tests/anonymous-request/request.golden <(curl  --silent --insecure https://${IP}:6443/)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "check anonymous request to apiserver on node2" {
  IP=`grep -o '2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run diff tests/anonymous-request/request.golden <(curl  --silent --insecure https://${IP}:6443/)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "check anonymous request to apiserver on local https node1" {
  NODE=`grep -o '.*1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run diff tests/anonymous-request/request-ansible.golden <(ansible -i inventory ${NODE} -m shell -a "curl  --silent --insecure https://127.0.0.1:6443/" | tail -n+2)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "check anonymous request to apiserver on local https node2" {
  NODE=`grep -o '.*2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  run diff tests/anonymous-request/request-ansible.golden <(ansible -i inventory ${NODE} -m shell -a "curl  --silent --insecure https://127.0.0.1:6443/" | tail -n+2)
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test "check anonymous request to etcd client node1" {
  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k --max-time 2s --connect-timeout 2s https://${IP}:2379/
  [ "$status" -ne 0 ]
}

@test "check anonymous request to etcd server node1" {
  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k --max-time 2s --connect-timeout 2s https://${IP}:2380/
  [ "$status" -ne 0 ]
}

@test "check anonymous request to etcd client node2" {
  IP=`grep -o '2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k --max-time 2s --connect-timeout 2s https://${IP}:2379/
  [ "$status" -ne 0 ]
}

@test "check anonymous request to etcd server node2" {
  IP=`grep -o '2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k --max-time 2s --connect-timeout 2s https://${IP}:2380/
  [ "$status" -ne 0 ]
}

@test "check anonymous request to etcd client node3" {
  IP=`grep -o '3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k --max-time 2s --connect-timeout 2s https://${IP}:2379/
  [ "$status" -ne 0 ]
}

@test "check anonymous request to etcd server node3" {
  IP=`grep -o '3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run curl -k --max-time 2s --connect-timeout 2s https://${IP}:2380/
  [ "$status" -ne 0 ]
}

@test "check anonymous request to kubelet on node1" {
  NODE=`grep -o '.*1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  IP=`grep -o '1 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run ansible -i inventory ${NODE} -m shell -a "sh -c 'curl  --silent --insecure https://${IP}:10250/metrics | grep Unauthorized'"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = 'Unauthorized' ]
}

@test "check anonymous request to kubelet on node2" {
  NODE=`grep -o '.*2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  IP=`grep -o '2 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run ansible -i inventory ${NODE} -m shell -a "sh -c 'curl  --silent --insecure https://${IP}:10250/metrics | grep Unauthorized'"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = 'Unauthorized' ]
}

@test "check anonymous request to kubelet on node3" {
  NODE=`grep -o '.*3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  IP=`grep -o '3 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run ansible -i inventory ${NODE} -m shell -a "sh -c 'curl  --silent --insecure https://${IP}:10250/metrics | grep Unauthorized'"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = 'Unauthorized' ]
}

@test "check anonymous request to kubelet on node4" {
  NODE=`grep -o '.*4 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | awk '{print $1;}'`
  IP=`grep -o '4 ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' inventory | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
  run ansible -i inventory ${NODE} -m shell -a "sh -c 'curl  --silent --insecure https://${IP}:10250/metrics | grep Unauthorized'"
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[1]}" = 'Unauthorized' ]
}
