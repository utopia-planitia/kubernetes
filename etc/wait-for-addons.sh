#!/bin/bash

set -e

WEAVE_PODS=$(seq 1 4)
KUBE_DNS_PODS=$(seq 1 2)

for POD in $WEAVE_PODS; do
  echo waiting for ${POD}/4 weave pods
  until [[ $( kubectl -n kube-system get po -l name=weave-net --no-headers=true | wc -l ) -ge "${POD}" ]]; do
   sleep 0.5
   echo .
  done
  echo done
done

for POD in $KUBE_DNS_PODS; do
  echo waiting for ${POD}/2 kube-dns pods
  until [[ $( kubectl -n kube-system get po -l k8s-app=kube-dns --no-headers=true | wc -l ) -ge "${POD}" ]]; do
   sleep 0.5
   echo .
  done
  echo done
done
