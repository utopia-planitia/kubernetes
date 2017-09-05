#!/usr/bin/env bats

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
