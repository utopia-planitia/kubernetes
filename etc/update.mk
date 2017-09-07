
.PHONY: update-weave
update-weave: ##@development update weave
	$(CLI) bash ./etc/update-weave.sh

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
