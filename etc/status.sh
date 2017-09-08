#!/bin/bash

date

echo
CS_COUNT=$( kubectl get componentstatus --no-headers=true | wc -l )
CS_READY=$( kubectl get componentstatus --no-headers=true | grep Healthy | wc -l )
if [[ "${CS_COUNT}" = "${CS_READY}" ]]; then
	echo "all master components are healthy"
else
	kubectl get componentstatus | head -n 1
	kubectl get componentstatus --no-headers=true| sort
fi

echo
NODES_COUNT=$( kubectl get no --no-headers=true | wc -l )
NODES_READY=$( kubectl get no --no-headers=true | grep Ready | wc -l )
echo "${NODES_READY} nodes are ready"
if [[ ! "${NODES_COUNT}" = "${NODES_READY}" ]]; then
	kubectl get no | grep -v Ready
fi

echo
PODS_COUNT=$( kubectl get po --all-namespaces=true --no-headers=true | wc -l )
PODS_READY=$( kubectl get po --all-namespaces=true --no-headers=true | grep Running | wc -l )
echo "${PODS_READY} pods are running"
if [[ ! "${PODS_COUNT}" = "${PODS_READY}" ]]; then
	kubectl get po --all-namespaces=true -o wide | grep -v Running
fi
