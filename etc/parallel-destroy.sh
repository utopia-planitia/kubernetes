#!/bin/sh

vagrant destroy -f node1 &
sleep 1
vagrant destroy -f node2 &
sleep 1
vagrant destroy -f node3 &
sleep 1
vagrant destroy -f node4 &
wait