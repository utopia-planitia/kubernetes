#/bin/bash

set -euxo pipefail

curl --fail -Lo roles/node/files/weave https://github.com/weaveworks/weave/releases/download/v2.5.0/weave
# https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
curl --fail -Lo addons/weave-daemonset-k8s.yaml "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d "\n")&password-secret=weave-password&trusted-subnets=10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,127.0.0.0/8,169.254.0.0/16&env.KUBERNETES_SERVICE_HOST=127.0.0.1&env.KUBERNETES_SERVICE_PORT=6443&env.IPALLOC_RANGE=10.48.0.0/12"
