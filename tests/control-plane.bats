#!/usr/bin/env bats

# Kubelets
@test "node1: check kubelet" {
  result="$( ansible -i inventory node1 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}
@test "node2: check kubelet" {
  result="$( ansible -i inventory node2 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}
@test "node3: check kubelet" {
  result="$( ansible -i inventory node3 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}
@test "node4: check kubelet" {
  result="$( ansible -i inventory node4 -m raw -a "curl 127.0.0.1:10248/healthz | grep ok" )"
  [[ "$status" -eq 0 ]]
}

# Etcd
@test "node1: wait for etcd" {
  until [[ $( ansible -i inventory node1 -m shell -a "docker ps" | grep " k8s_etcd_etcd" | wc -l ) = "1" ]]; do
   sleep 0.5
  done
}
@test "node2: wait for etcd" {
  until [[ $( ansible -i inventory node2 -m shell -a "docker ps" | grep " k8s_etcd_etcd" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node3: wait for etcd" {
  until [[ $( ansible -i inventory node3 -m shell -a "docker ps" | grep " k8s_etcd_etcd" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}

@test "node1: check etcd" {
  result="$( ansible -i inventory node1 -m shell -a "docker exec \`docker ps | grep k8s_etcd_etcd | head -c 12\` etcdctl cluster-health" | grep "cluster is healthy")"
  [ "$result" == "cluster is healthy" ]
}
@test "node2: check etcd" {
  result="$( ansible -i inventory node2 -m shell -a "docker exec \`docker ps | grep k8s_etcd_etcd | head -c 12\` etcdctl cluster-health" | grep "cluster is healthy")"
  [ "$result" == "cluster is healthy" ]
}
@test "node3: check etcd" {
  result="$( ansible -i inventory node3 -m shell -a "docker exec \`docker ps | grep k8s_etcd_etcd | head -c 12\` etcdctl cluster-health" | grep "cluster is healthy")"
  [ "$result" == "cluster is healthy" ]
}

# Masters
@test "node1: wait for apiserver" {
  until [[ $( ansible -i inventory node1 -m shell -a "docker ps" | grep " k8s_apiserver_master" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for apiserver" {
  until [[ $( ansible -i inventory node2 -m shell -a "docker ps" | grep " k8s_apiserver_master" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node1: wait for scheduler" {
  until [[ $( ansible -i inventory node1 -m shell -a "docker ps" | grep " k8s_scheduler_master" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for scheduler" {
  until [[ $( ansible -i inventory node2 -m shell -a "docker ps" | grep " k8s_scheduler_master" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node1: wait for controller-manager" {
  until [[ $( ansible -i inventory node1 -m shell -a "docker ps" | grep " k8s_controller-manager_master" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for controller-manager" {
  until [[ $( ansible -i inventory node2 -m shell -a "docker ps" | grep " k8s_controller-manager_master" | wc -l ) = "1" ]]; do
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



# Master proxies
@test "node3: wait for master-proxy" {
  until [[ $( ansible -i inventory node3 -m shell -a "docker ps" | grep " k8s_forwarder_master-proxy" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node4: wait for master-proxy" {
  until [[ $( ansible -i inventory node4 -m shell -a "docker ps" | grep " k8s_forwarder_master-proxy" | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}

@test "node3: check master-proxy" {
  result="$( ansible -i inventory node3 -m raw -a "curl -k https://127.0.0.1:6443/ | grep Unauthorized")"
  [[ "$status" -eq 0 ]]
}
@test "node4: check master-proxy" {
  result="$( ansible -i inventory node4 -m raw -a "curl -k https://127.0.0.1:6443/ | grep Unauthorized")"
  [[ "$status" -eq 0 ]]
}

# registered Nodes
@test "node1: wait for registration" {  
  until [[ $( kubectl get no --no-headers=true | grep node1 | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for registration" {
  until [[ $( kubectl get no --no-headers=true | grep node2 | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node3: wait for registration" {
  until [[ $( kubectl get no --no-headers=true | grep node3 | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node4: wait for registration" {
  until [[ $( kubectl get no --no-headers=true | grep node4 | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}

# Kube-Proxy
@test "node1: wait for kube-proxy" {  
  until [[ $( kubectl -n kube-system get po -l name=kube-proxy,host=node1 --no-headers=true | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node2: wait for kube-proxy" {  
  until [[ $( kubectl -n kube-system get po -l name=kube-proxy,host=node2 --no-headers=true | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node3: wait for kube-proxy" {  
  until [[ $( kubectl -n kube-system get po -l name=kube-proxy,host=node3 --no-headers=true | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
@test "node4: wait for kube-proxy" {  
  until [[ $( kubectl -n kube-system get po -l name=kube-proxy,host=node4 --no-headers=true | wc -l ) = "1" ]]; do
    sleep 0.5
  done
}
