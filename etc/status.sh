#!/bin/bash

date

CS=$( kubectl get componentstatus )
CS_COUNT=$( echo "$CS" | tail -n +2 | wc -l )
CS_READY=$( echo "$CS" | tail -n +2 | grep Healthy | wc -l )
if [[ "${CS_COUNT}" = "${CS_READY}" ]]; then
	echo "all master components are healthy"
else
	echo "$CS" | head -n 1
	echo "$CS" | tail -n +2 | sort
fi

NODES=$( kubectl get no )
NODES_COUNT=$( echo "$NODES" | tail -n +2 | wc -l )
NODES_READY=$( echo "$NODES" | tail -n +2 | grep Ready | wc -l )
echo "${NODES_READY} of ${NODES_COUNT} nodes are ready"
if [[ ! "${NODES_READY}" = "${NODES_COUNT}" ]]; then
	echo "$NODES" | head -n 1
	echo "$NODES" | tail -n +2 | grep -v Ready | sort
fi

PODS=$( kubectl get po --all-namespaces=true )
PODS_COUNT=$( echo "$PODS" | tail -n +2 | wc -l )
PODS_READY=$( echo "$PODS" | tail -n +2 | grep Running | wc -l )
echo "${PODS_READY} of ${PODS_COUNT} pods are running"
if [[ ! "${PODS_COUNT}" = "${PODS_READY}" ]]; then
	echo "$PODS" | head -n 1
	echo "$PODS" | tail -n +2 | grep -v Running | sort
fi
