#!/bin/sh

GREEN=$(tput -Txterm setaf 2)
YELLOW=$(tput -Txterm setaf 3)
RESET=$(tput -Txterm sgr0)

echo searching for docker
which docker
if [ $? != 0 ]; then
    echo ${YELLOW}docker is missing${RESET}
    exit 1
else
    echo ${GREEN}docker was found${RESET}
fi

echo searching for vagrant
which vagrant
if [ $? != 0 ]; then
    echo ${YELLOW}vagrant is missing${RESET}
    exit 1
else
    echo ${GREEN}vagrant was found${RESET}
fi

echo searching for virtualbox
which virtualbox
if [ $? != 0 ]; then
    echo ${YELLOW}virtualbox is missing${RESET}
    exit 1
else
    echo ${GREEN}virtualbox was found${RESET}
fi