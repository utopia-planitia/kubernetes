
.PHONY: update-weave
update-weave: ##@update weave
	curl -Lo roles/node/files/weave https://github.com/weaveworks/weave/releases/download/v2.5.1/weave
	# https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
	curl -Lo addons/weave-daemonset-k8s.yaml "https://cloud.weave.works/k8s/net?k8s-version=Q2xpZW50IFZlcnNpb246IHZlcnNpb24uSW5mb3tNYWpvcjoiMSIsIE1pbm9yOiIxMCIsIEdpdFZlcnNpb246InYxLjEwLjEiLCBHaXRDb21taXQ6ImQ0YWI0NzUxODgzNmM3NTBmOTk0OWI5ZTBkMzg3ZjIwZmI5MjI2MGIiLCBHaXRUcmVlU3RhdGU6ImNsZWFuIiwgQnVpbGREYXRlOiIyMDE4LTA0LTEyVDE0OjI2OjA0WiIsIEdvVmVyc2lvbjoiZ28xLjkuMyIsIENvbXBpbGVyOiJnYyIsIFBsYXRmb3JtOiJsaW51eC9hbWQ2NCJ9ClNlcnZlciBWZXJzaW9uOiB2ZXJzaW9uLkluZm97TWFqb3I6IjEiLCBNaW5vcjoiMTAiLCBHaXRWZXJzaW9uOiJ2MS4xMC4yIiwgR2l0Q29tbWl0OiI4MTc1M2IxMGRmMTEyOTkyYmY1MWJiYzJjMmY4NTIwOGFhZDc4MzM1IiwgR2l0VHJlZVN0YXRlOiJjbGVhbiIsIEJ1aWxkRGF0ZToiMjAxOC0wNC0yN1QwOToxMDoyNFoiLCBHb1ZlcnNpb246ImdvMS45LjMiLCBDb21waWxlcjoiZ2MiLCBQbGF0Zm9ybToibGludXgvYW1kNjQifQo=&env.KUBERNETES_SERVICE_HOST=127.0.0.1&env.KUBERNETES_SERVICE_PORT=6443&env.IPALLOC_RANGE=10.48.0.0/12&env.WEAVE_MTU=1332"

.PHONY: update-metrics-server
update-metrics-server: ##@update update weave
	mkdir -p addons/metrics-server
	curl -o addons/metrics-server/aggregated-metrics-reader.yaml https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/aggregated-metrics-reader.yaml
	curl -o addons/metrics-server/auth-delegator.yaml            https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/auth-delegator.yaml
	curl -o addons/metrics-server/auth-reader.yaml               https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/auth-reader.yaml
	curl -o addons/metrics-server/metrics-apiservice.yaml        https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/metrics-apiservice.yaml
	curl -o addons/metrics-server/metrics-server-deployment.yaml https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/metrics-server-deployment.yaml
	curl -o addons/metrics-server/metrics-server-service.yaml    https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/metrics-server-service.yaml
	curl -o addons/metrics-server/resource-reader.yaml           https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/resource-reader.yaml
