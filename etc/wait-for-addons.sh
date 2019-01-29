#!/bin/bash

set -e

NODES_COUNT=$( grep ansible_host inventory | wc -l)
CORE_DNS_PODS=$( grep ansible_host inventory | wc -l)

for ID in $(seq 1 ${CORE_DNS_PODS}); do
  echo waiting for ${ID}/${CORE_DNS_PODS} core-dns pods
  until [[ $( kubectl -n kube-system get po -l k8s-app=kube-dns --no-headers=true | grep Running | grep 2/2 | wc -l ) -ge "${ID}" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done
