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
