#!/bin/bash

EXIT_CODE=0

date

CS=$( kubectl get componentstatus )
CS_COUNT=$( echo "$CS" | tail -n +2 | wc -l )
CS_READY=$( echo "$CS" | tail -n +2 | grep Healthy | wc -l )
if [[ "${CS_COUNT}" = "${CS_READY}" ]]; then
	echo "all master components are healthy"
else
	echo "$CS" | head -n 1
	echo "$CS" | tail -n +2 | sort
	EXIT_CODE=40
fi

NODES=$( kubectl get no -o wide 2>&1 | grep -v 'No resources found.' )
NODES_COUNT=$( echo "$NODES" | tail -n +2 | wc -l )
NODES_READY=$( echo "$NODES" | tail -n +2 | grep -v NotReady | wc -l )
echo "${NODES_READY} of ${NODES_COUNT} nodes are ready"
if [[ ! "${NODES_READY}" = "${NODES_COUNT}" ]]; then
	echo "$NODES" | head -n 1
	echo "$NODES" | tail -n +2 | grep -v " Ready" | sort
	EXIT_CODE=41
fi

VOLUMES=$( kubectl get pv 2>&1 | grep -v 'No resources found.' )
VOLUMES_COUNT=$( echo "$VOLUMES" | tail -n +2 | wc -l )
VOLUMES_BOUND_AVAILABLE=$( echo "$VOLUMES" | tail -n +2 | grep -e Bound -e Available | wc -l )
echo "${VOLUMES_BOUND_AVAILABLE} of ${VOLUMES_COUNT} volumes are bound or available"
if [[ ! "${VOLUMES_BOUND_AVAILABLE}" = "${VOLUMES_COUNT}" ]]; then
	echo "$VOLUMES" | head -n 1
	echo "$VOLUMES" | tail -n +2 | grep -v -e Bound -e Available | sort
	EXIT_CODE=42
fi

NAMESPACES=$( kubectl get ns )
NAMESPACES_COUNT=$( echo "$NAMESPACES" | tail -n +2 | wc -l )
NAMESPACES_ACTIVE=$( echo "$NAMESPACES" | tail -n +2 | grep Active | wc -l )
echo "${NAMESPACES_ACTIVE} of ${NAMESPACES_COUNT} namespaces are active"
if [[ ! "${NAMESPACES_ACTIVE}" = "${NAMESPACES_COUNT}" ]]; then
	echo "$NAMESPACES" | head -n 1
	echo "$NAMESPACES" | tail -n +2 | grep -v Active | sort
	EXIT_CODE=43
fi

CLAIMS=$( kubectl get --all-namespaces=true pvc 2>&1 | grep -v 'No resources found.' )
CLAIMS_COUNT=$( echo "$CLAIMS" | tail -n +2 | wc -l )
CLAIMS_BOUND_AVAILABLE=$( echo "$CLAIMS" | tail -n +2 | grep -e Bound | wc -l )
echo "${CLAIMS_BOUND_AVAILABLE} of ${CLAIMS_COUNT} volume claims are bound"
if [[ ! "${CLAIMS_BOUND_AVAILABLE}" = "${CLAIMS_COUNT}" ]]; then
	echo "$CLAIMS" | head -n 1
	echo "$CLAIMS" | tail -n +2 | grep -v -e Bound | sort
	EXIT_CODE=44
fi

PODS=$( kubectl get po --all-namespaces=true -o wide 2>&1 | grep -v 'No resources found.' )
PODS_COUNT=$( echo "$PODS" | tail -n +2 | wc -l )
PODS_READY=$( echo "$PODS" | tail -n +2 | grep 'Running\|Completed' | wc -l )
echo "${PODS_READY} of ${PODS_COUNT} pods are running/completed"
if [[ ! "${PODS_COUNT}" = "${PODS_READY}" ]]; then
	echo "$PODS" | head -n 1
	echo "$PODS" | tail -n +2 | grep -v 'Running\|Completed' | sort
	EXIT_CODE=45
fi

exit $EXIT_CODE
