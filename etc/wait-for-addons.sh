#!/bin/bash

set -e

WEAVE_PODS=4
KUBE_DNS_PODS=2

for ID in $(seq 1 ${WEAVE_PODS}); do
  echo waiting for ${ID}/${WEAVE_PODS} weave pods
  until [[ $( kubectl -n kube-system get po -l name=weave-net --no-headers=true | grep Running | grep 2/2 | wc -l ) -ge "${POD}" ]]; do
   sleep 0.5
   echo .
  done
  echo done
done

for ID in $(seq 1 ${KUBE_DNS_PODS}); do
  echo waiting for ${ID}/${KUBE_DNS_PODS} kube-dns pods
  until [[ $( kubectl -n kube-system get po -l k8s-app=kube-dns --no-headers=true | grep Running | grep 3/3 | wc -l ) -ge "${POD}" ]]; do
   sleep 0.5
   echo .
  done
  echo done
done
