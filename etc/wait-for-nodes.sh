#!/bin/bash

set -e

NODES=4

for ID in $(seq 1 $NODES); do
  echo waiting for ${ID}/${NODES} node registrations
  until [[ $( kubectl get no --no-headers=true | wc -l ) -ge "${ID}" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done

for ID in $(seq 1 $NODES); do
  echo waiting for ${ID}/${NODES} kube-proxy
  until [[ $( kubectl -n kube-system get po -l name=kube-proxy --no-headers=true | wc -l ) -ge "${ID}" ]]; do
   sleep 0.5
  done
  echo done
done
