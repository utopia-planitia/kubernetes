#!/bin/bash

set -e

NODES_COUNT=$( grep ansible_host inventory | wc -l)

for ID in $(seq 1 ${NODES_COUNT}); do
  echo waiting for ${ID}/${NODES_COUNT} cilium pods
  until [[ $( kubectl -n kube-system get po -l k8s-app=cilium --no-headers=true --ignore-not-found=true | grep Running | grep 1/1 | wc -l ) -ge "${ID}" ]]; do
   sleep 1
   echo -n .
  done
  echo done
done

for ID in $(seq 1 3); do
  echo waiting for ${ID}/3 core-dns pods
  until [[ $( kubectl -n kube-system get po -l k8s-app=kube-dns --no-headers=true --ignore-not-found=true | grep Running | grep 1/1 | wc -l ) -ge "${ID}" ]]; do
   sleep 1
   echo -n .
  done
  echo done
done

for ID in $(seq 1 ${NODES_COUNT}); do
  echo waiting for ${ID}/${NODES_COUNT} node-local-dns pods
  until [[ $( kubectl -n kube-system get po -l k8s-app=node-local-dns --no-headers=true --ignore-not-found=true | grep Running | grep 1/1 | wc -l ) -ge "${ID}" ]]; do
   sleep 1
   echo -n .
  done
  echo done
done
