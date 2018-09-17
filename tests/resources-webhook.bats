#!/usr/bin/env bats

# it should
    # wait for the resources-webhook pod/pods running
        # verify resources-webhook node1
        # verify resources-webhook node2 
    # wait till the mutationwebhook config is applied
    # create a test pod with and without compute resources
        # check for expected behavior (resources are set for missing compute resources)

