#!/bin/bash

set -e

until [[ $( kubectl get ns -o=name | grep namespaces/e2e | wc -l ) -eq "0" ]]; do
  echo deleting namespaces
  kubectl get ns -o=name | grep namespaces/e2e | xargs -r -n1 kubectl delete
  sleep 0.5
  until [[ $( kubectl get ns | grep Terminating | wc -l ) -eq "0" ]]; do
    echo $( kubectl get ns -o=name | grep namespaces/e2e | wc -l ) namespaces left
    sleep 0.5
  done
done
