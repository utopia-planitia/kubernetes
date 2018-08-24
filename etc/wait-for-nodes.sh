#!/bin/bash

set -e

NODES_COUNT=$( grep ansible_host inventory | wc -l)

for ID in $(seq 1 $NODES_COUNT); do
  echo waiting for ${ID}/${NODES_COUNT} node registrations
  until [[ $( kubectl get no --no-headers=true 2>&1 | grep Ready | wc -l ) -ge "${ID}" ]]; do
   sleep 2
   echo -n .
  done
  echo done
done

for ID in $(seq 1 $NODES_COUNT); do
  echo waiting for ${ID}/${NODES_COUNT} kube-proxy
  until [[ $( kubectl -n kube-system get po -l name=kube-proxy --no-headers=true 2>&1 | grep Running | grep 1/1  | wc -l ) -ge "${ID}" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done
