#!/bin/sh

vagrant up node1 &
sleep 1
vagrant up node2 &
sleep 1
vagrant up node3 &
sleep 1
vagrant up node4 &
wait