#!/bin/bash

set -e

NODES_COUNT=$( grep ansible_host inventory | wc -l)
KUBE_DNS_PODS=2

for ID in $(seq 1 ${NODES_COUNT}); do
  echo waiting for ${ID}/${NODES_COUNT} weave pods
  until [[ $( kubectl -n kube-system get po -l name=weave-net --no-headers=true | grep Running | grep 2/2 | wc -l ) -ge "${ID}" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done

for ID in $(seq 1 ${KUBE_DNS_PODS}); do
  echo waiting for ${ID}/${KUBE_DNS_PODS} kube-dns pods
  until [[ $( kubectl -n kube-system get po -l k8s-app=kube-dns --no-headers=true | grep Running | grep 3/3 | wc -l ) -ge "${ID}" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done
