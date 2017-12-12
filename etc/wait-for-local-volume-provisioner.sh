#!/bin/bash

set -e

NODES_COUNT=$( grep ansible_host inventory | wc -l)

for ID in $(seq 1 ${NODES_COUNT}); do
  echo waiting for ${ID}/${NODES_COUNT} local-volume-provisioner pods
  until [[ $( kubectl -n kube-system get po -l app=local-volume-provisioner --no-headers=true | grep Running | grep 1/1 | wc -l ) -ge "${ID}" ]]; do
   sleep 0.5
   echo -n .
  done
  echo done
done
