#!/bin/bash

set -e

WEAVE_PODS=$(seq 1 4)

for WEAVE_POD in $WEAVE_PODS; do
  echo waiting for ${WEAVE_POD}/4 weave pods
  until [[ $( kubectl -n kube-system get po -l name=weave-net --no-headers=true | wc -l ) -ge "${WEAVE_POD}" ]]; do
   sleep 0.5
   echo .
  done
  echo done
done
