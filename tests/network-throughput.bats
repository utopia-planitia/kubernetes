#!/usr/bin/env bats

load test_helper

# Retry a command $1 times until it succeeds. Wait $2 seconds between retries.
function retry {
    local attempts=$1
    shift
    local delay=$1
    shift
    local i

    for ((i=0; i < attempts; i++)); do
        run "$@"
        if [ "$status" -eq 0 ]; then
            return 0
        fi
        sleep $delay
    done

    echo "Command \"$*\" failed $attempts times. Status: $status. Output: $output" >&2
    false
}

@test "deploy throughput test environment" {
  run kubectl apply -f tests/network-throughput
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}

@test "create random file" {
  until [ $(kubectl get pod transmit --no-headers | grep Running | grep 1/1 | wc -l) -eq 1 ]; do
    sleep 0.5
  done
  until [ $(kubectl get pod receive --no-headers | grep Running | grep 1/1 | wc -l) -eq 1 ]; do
    sleep 0.5
  done

  run kubectl exec transmit -- dd if=/dev/urandom of=/file bs=1M count=100
  [ $status -eq 0 ]
}

@test "install curl" {
  run kubectl exec transmit -- apk --update add curl
  [ $status -eq 0 ]
}

@test "http curl receiver" {
  run retry 12 4 timeout 1 kubectl exec transmit -- curl http://receive/ 
  [ $status -eq 0 ]
}

@test "check transfer time" {
  run retry 3 4 timeout 4 kubectl exec transmit -- curl -T file http://receive/file
  [ $status -eq 0 ]
}

@test "undeploy throughput test environment" {
  run kubectl delete -f tests/network-throughput
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]

  until [ $(kubectl get pod transmit --no-headers | wc -l) -eq 0 ]; do
    sleep 0.5
  done
  until [ $(kubectl get pod receive --no-headers | wc -l) -eq 0 ]; do
    sleep 0.5
  done
}
