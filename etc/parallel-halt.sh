#!/bin/sh

vagrant halt node1 &
sleep 1
vagrant halt node2 &
sleep 1
vagrant halt node3 &
sleep 1
vagrant halt node4 &
wait