#!/usr/bin/env bats

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
