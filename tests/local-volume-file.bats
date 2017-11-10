#!/usr/bin/env bats

@test "pv file: deploy pod with persistent local volume" {
  run kubectl apply -f tests/local-volume-file
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
}

@test "pv file: list empty volume" {
  if [ "$SKIP_LOCAL_VOLUME_FILE_TESTS" == "true" ]; then
    skip "skip file based local volume tests"
  fi
  until [ $(kubectl get pod -a local-pod-file --no-headers | grep Running | wc -l) == 1 ]; do
    sleep 0.5
  done
  run kubectl exec local-pod-file -- ls -1 /data/
  [ $status == 0 ]
  [ "${#lines[@]}" == 0 ]
}

@test "pv file: write into volume" {
  if [ "$SKIP_LOCAL_VOLUME_FILE_TESTS" == "true" ]; then
    skip "skip file based local volume tests"
  fi
  until [ $(kubectl get pod -a local-pod-file --no-headers | grep Running | wc -l) == 1 ]; do
    sleep 0.5
  done
  run kubectl exec local-pod-file -- touch /data/file
  [ $status == 0 ]
  [ "${#lines[@]}" == 0 ]
}

@test "pv file: list written volume" {
  if [ "$SKIP_LOCAL_VOLUME_FILE_TESTS" == "true" ]; then
    skip "skip file based local volume tests"
  fi
  until [ $(kubectl get pod -a local-pod-file --no-headers | grep Running | wc -l) == 1 ]; do
    sleep 0.5
  done
  run kubectl exec local-pod-file -- ls -1 /data/
  [ $status == 0 ]
  [ "${#lines[@]}" == 1 ]
}

@test "pv file: delete pod" {
  if [ "$SKIP_LOCAL_VOLUME_FILE_TESTS" == "true" ]; then
    skip "skip file based local volume tests"
  fi
  run kubectl delete -f tests/local-volume-file/pod.yaml
  [ $status == 0 ]
  [ "${#lines[@]}" == 1 ]
}

@test "pv file: recreate pod" {
  if [ "$SKIP_LOCAL_VOLUME_FILE_TESTS" == "true" ]; then
    skip "skip file based local volume tests"
  fi
  until [ $(kubectl get pod -a local-pod-file --no-headers | wc -l) == 0 ]; do
    sleep 0.5
  done
  run kubectl apply -f tests/local-volume-file/pod.yaml
  [ $status == 0 ]
  [ "${#lines[@]}" == 1 ]
}

@test "pv file: list recreated volume" {
  if [ "$SKIP_LOCAL_VOLUME_FILE_TESTS" == "true" ]; then
    skip "skip file based local volume tests"
  fi
  until [ $(kubectl get pod -a local-pod-file --no-headers | grep Running | wc -l) == 1 ]; do
    sleep 0.5
  done
  run kubectl exec local-pod-file -- ls -1 /data/
  [ $status == 0 ]
  [ "${#lines[@]}" == 1 ]
}

@test "pv file: undeploy pod with persistent local volume" {
  run kubectl delete -f tests/local-volume-file
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
}
