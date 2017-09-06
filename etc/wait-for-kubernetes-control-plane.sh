#!/bin/bash

set -e

MASTERS=$(seq 1 2)
MASTERPROXIES=$(seq 3 4)
ETCD=$(seq 1 3)
NODES=$(seq 1 4)

for ID in $NODES; do
  echo waiting for kubelet on node${ID}
  until [[ $( ansible -i inventory node${ID} -m raw -a "curl 127.0.0.1:10248/healthz" | grep ok | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done

for ID in $ETCD; do
  echo waiting for etcd${ID}
  until [[ $( ansible -i inventory node${ID} -m shell -a "docker ps" | grep " k8s_etcd_etcd" | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done

for ID in $ETCD; do
  echo waiting for etcd${ID} health check
  until [[ $( ansible -i inventory node${ID} -m shell -a "docker exec \`docker ps | grep k8s_etcd_etcd | head -c 12\` etcdctl cluster-health" | grep "cluster is healthy" | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done

for ID in $MASTERS; do
  echo waiting for master${ID}
  echo 1/3 waiting for apiserver
  until [[ $( ansible -i inventory node${ID} -m shell -a "docker ps" | grep " k8s_apiserver_master" | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
  echo 2/3 waiting for scheduler
  until [[ $( ansible -i inventory node${ID} -m shell -a "docker ps" | grep " k8s_scheduler_master" | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
  echo 3/3 waiting for controller-manager
  until [[ $( ansible -i inventory node${ID} -m shell -a "docker ps" | grep " k8s_controller-manager_master" | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done

for ID in $MASTERS; do
  echo waiting for master${ID} health check
  echo 1/3 waiting for apiserver health check
  until [[ $( ansible -i inventory node${ID} -m raw -a "curl http://127.0.0.1:8080/healthz" | grep ok | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
  echo 2/3 waiting for scheduler health check
  until [[ $( ansible -i inventory node${ID} -m raw -a "curl http://127.0.0.1:10251/healthz" | grep ok | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
  echo 3/3 waiting for controller-manager health check
  until [[ $( ansible -i inventory node${ID} -m raw -a "curl http://127.0.0.1:10252/healthz" | grep ok | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done

for ID in $MASTERPROXIES; do
  echo waiting for master-proxy${ID}
  until [[ $( ansible -i inventory node${ID} -m shell -a "docker ps" | grep " k8s_forwarder_master-proxy" | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done

for ID in $NODES; do
  echo waiting for node${ID} port 6443
  until [[ $( ansible -i inventory node${ID} -m raw -a "curl -k https://127.0.0.1:6443/" | grep Unauthorized | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done

for ID in $NODES; do
  echo waiting for node${ID} registration
  until [[ $( kubectl get no --no-headers=true | grep node${ID} | wc -l ) = "1" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done

for ID in $NODES; do
  echo waiting for node${ID} kube-proxy
  until [[ $( kubectl -n kube-system get po -l name=kube-proxy,host=node${ID} --no-headers=true | wc -l ) = "1" ]]; do
   sleep 0.5
  done
  echo done
done
