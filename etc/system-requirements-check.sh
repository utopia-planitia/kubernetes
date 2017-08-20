#!/bin/bash

GREEN=$(tput -Txterm setaf 2)
YELLOW=$(tput -Txterm setaf 3)
RESET=$(tput -Txterm sgr0)

function searchFor {
    echo searching for $1
    which $1
    if [ $? != 0 ]; then
        echo ${YELLOW}$1 is missing${RESET}
        exit 1
    else
        echo ${GREEN}$1 was found${RESET}
    fi
}

searchFor docker
searchFor vagrant
searchFor virtualbox
searchFor envsubst
