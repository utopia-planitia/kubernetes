
.PHONY: update-
update-: ##@development update 
	curl -Lo roles/node/files/ https://github.com/works//releases/download/v2.4.1/
	# https://www..works/docs/net/latest/kubernetes/kube-addon/
	curl -Lo addons/-daemonset-k8s.yaml "https://cloud..works/k8s/net?k8s-version=Q2xpZW50IFZlcnNpb246IHZlcnNpb24uSW5mb3tNYWpvcjoiMSIsIE1pbm9yOiIxMCIsIEdpdFZlcnNpb246InYxLjEwLjEiLCBHaXRDb21taXQ6ImQ0YWI0NzUxODgzNmM3NTBmOTk0OWI5ZTBkMzg3ZjIwZmI5MjI2MGIiLCBHaXRUcmVlU3RhdGU6ImNsZWFuIiwgQnVpbGREYXRlOiIyMDE4LTA0LTEyVDE0OjI2OjA0WiIsIEdvVmVyc2lvbjoiZ28xLjkuMyIsIENvbXBpbGVyOiJnYyIsIFBsYXRmb3JtOiJsaW51eC9hbWQ2NCJ9ClNlcnZlciBWZXJzaW9uOiB2ZXJzaW9uLkluZm97TWFqb3I6IjEiLCBNaW5vcjoiMTAiLCBHaXRWZXJzaW9uOiJ2MS4xMC4yIiwgR2l0Q29tbWl0OiI4MTc1M2IxMGRmMTEyOTkyYmY1MWJiYzJjMmY4NTIwOGFhZDc4MzM1IiwgR2l0VHJlZVN0YXRlOiJjbGVhbiIsIEJ1aWxkRGF0ZToiMjAxOC0wNC0yN1QwOToxMDoyNFoiLCBHb1ZlcnNpb246ImdvMS45LjMiLCBDb21waWxlcjoiZ2MiLCBQbGF0Zm9ybToibGludXgvYW1kNjQifQo=&password-secret=-password&trusted-subnets=10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,127.0.0.0/8,169.254.0.0/16&env.KUBERNETES_SERVICE_HOST=127.0.0.1&env.KUBERNETES_SERVICE_PORT=6443&env.IPALLOC_RANGE=10.48.0.0/12"
