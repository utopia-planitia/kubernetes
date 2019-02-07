#!/bin/bash

set -e

NODES_COUNT=$( grep ansible_host inventory | wc -l)
CORE_DNS_PODS=$( grep ansible_host inventory | wc -l)

for ID in $(seq 1 ${CORE_DNS_PODS}); do
  echo waiting for ${ID}/${CORE_DNS_PODS} core-dns pods
  until [[ $( kubectl -n kube-system get po -l k8s-app=kube-dns --no-headers=true | grep Running | grep 2/2 | wc -l ) -ge "${ID}" ]]; do
   sleep 1
   echo -n .
  done
  echo done
done


NODES_COUNT=$( grep ansible_host inventory | wc -l)
KUBE_ROUTER_PODS=$( grep ansible_host inventory | wc -l)

for ID in $(seq 1 ${KUBE_ROUTER_PODS}); do
  echo waiting for ${ID}/${KUBE_ROUTER_PODS} kube-router pods
  until [[ $( kubectl -n kube-system get po -l k8s-app=kube-router --no-headers=true | grep Running | grep 1/1 | wc -l ) -ge "${ID}" ]]; do
   sleep 1
   echo -n .
  done
  echo done
done
