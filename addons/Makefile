
# https://docs.cilium.io/en/v1.6/gettingstarted/encryption/
# https://docs.cilium.io/en/v1.6/gettingstarted/cni-chaining-portmap/
# https://cilium.readthedocs.io/en/stable/kubernetes/troubleshooting/#troubleshooting-k8s
# https://docs.cilium.io/en/v1.6/troubleshooting/#checking-cluster-connectivity-health
# https://cilium.io/blog/2018/06/28/cilium-prometheus/

.PHONY: cilium.yaml
cilium.yaml:
	helm template cilium-repo/install/kubernetes/cilium/ \
	--namespace=kube-system \
	--set global.bpf.waitForMount=true \
	--set global.encryption.interface=eno1 \
	--set global.encryption.enabled=false \
	--set global.encryption.nodeEncryption=false \
	--set global.containerRuntime.integration=docker \
	--set global.prometheus.enabled=false \
	> cilium.yaml

#	--set global.autoDirectNodeRoutes=true \
#	--set global.nodePort.enabled=true \
#	--set global.cni.chainingMode=portmap \
