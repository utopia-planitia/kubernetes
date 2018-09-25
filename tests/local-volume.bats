#!/usr/bin/env bats

load test_helper

@test "pv quota: deploy pod with persistent local volume" {
  run kubectl apply -f tests/local-volume
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}

@test "pv quota: list empty volume" {
  if [ "$SKIP_LOCAL_VOLUME_QUOTA_TESTS" == "true" ]; then
    skip "skip quota based local volume tests"
  fi
  until [ $(kubectl get pod local-pod-quota --no-headers | grep Running | wc -l) == 1 ]; do
    sleep 0.5
  done
  run kubectl exec local-pod-quota -- ls -1 /data/
  [ $status == 0 ]
  [ "${#lines[@]}" == 0 ]
}

@test "pv quota: write into volume" {
  if [ "$SKIP_LOCAL_VOLUME_QUOTA_TESTS" == "true" ]; then
    skip "skip quota based local volume tests"
  fi
  until [ $(kubectl get pod local-pod-quota --no-headers | grep Running | wc -l) == 1 ]; do
    sleep 0.5
  done
  run kubectl exec local-pod-quota -- touch /data/file
  [ $status == 0 ]
  [ "${#lines[@]}" == 0 ]
}

@test "pv quota: list written volume" {
  if [ "$SKIP_LOCAL_VOLUME_QUOTA_TESTS" == "true" ]; then
    skip "skip quota based local volume tests"
  fi
  until [ $(kubectl get pod local-pod-quota --no-headers | grep Running | wc -l) == 1 ]; do
    sleep 0.5
  done
  run kubectl exec local-pod-quota -- ls -1 /data/
  [ $status == 0 ]
  [ "${#lines[@]}" == 1 ]
}

@test "pv quota: delete pod" {
  if [ "$SKIP_LOCAL_VOLUME_QUOTA_TESTS" == "true" ]; then
    skip "skip quota based local volume tests"
  fi
  run kubectl delete -f tests/local-volume/pod.yaml
  [ $status == 0 ]
  [ "${#lines[@]}" == 1 ]
}

@test "pv quota: recreate pod" {
  if [ "$SKIP_LOCAL_VOLUME_QUOTA_TESTS" == "true" ]; then
    skip "skip quota based local volume tests"
  fi
  until [ $(kubectl get pod local-pod-quota --no-headers | wc -l) == 0 ]; do
    sleep 0.5
  done
  run kubectl apply -f tests/local-volume/pod.yaml
  [ $status == 0 ]
  [ "${#lines[@]}" == 1 ]
}

@test "pv quota: list recreated volume" {
  if [ "$SKIP_LOCAL_VOLUME_QUOTA_TESTS" == "true" ]; then
    skip "skip quota based local volume tests"
  fi
  until [ $(kubectl get pod local-pod-quota --no-headers | grep Running | wc -l) == 1 ]; do
    sleep 0.5
  done
  run kubectl exec local-pod-quota -- ls -1 /data/
  [ $status == 0 ]
  [ "${#lines[@]}" == 1 ]
}

@test "pv quota: undeploy pod with persistent local volume" {
  run kubectl delete -f tests/local-volume
  [ $status -eq 0 ]
  [ "${#lines[@]}" -eq 3 ]
}
