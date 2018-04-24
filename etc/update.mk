
.PHONY: update-weave
update-weave: ##@development update weave
	curl -Lo roles/node/files/weave https://github.com/weaveworks/weave/releases/download/v2.3.0/weave
	# https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
	curl -Lo addons/weave-daemonset-k8s-1.7.yaml "https://cloud.weave.works/k8s/net?k8s-version=Q2xpZW50IFZlcnNpb246IHZlcnNpb24uSW5mb3tNYWpvcjoiMSIsIE1pbm9yOiI5IiwgR2l0VmVyc2lvbjoidjEuOS42IiwgR2l0Q29tbWl0OiI5ZjhlYmQxNzE0NzliZWMwYWRhODM3ZDdlZTY0MWRlYzJmOGM2ZGQxIiwgR2l0VHJlZVN0YXRlOiJjbGVhbiIsIEJ1aWxkRGF0ZToiMjAxOC0wMy0yMVQxNToyMTo1MFoiLCBHb1ZlcnNpb246ImdvMS45LjMiLCBDb21waWxlcjoiZ2MiLCBQbGF0Zm9ybToibGludXgvYW1kNjQifQpTZXJ2ZXIgVmVyc2lvbjogdmVyc2lvbi5JbmZve01ham9yOiIxIiwgTWlub3I6IjgiLCBHaXRWZXJzaW9uOiJ2MS44LjIiLCBHaXRDb21taXQ6ImJkYWVhZmE3MWY2YzdjMDQ2MzYyNTEwMzFmOTM0NjQzODRkNTQ5NjMiLCBHaXRUcmVlU3RhdGU6ImNsZWFuIiwgQnVpbGREYXRlOiIyMDE3LTEwLTI0VDE5OjM4OjEwWiIsIEdvVmVyc2lvbjoiZ28xLjguMyIsIENvbXBpbGVyOiJnYyIsIFBsYXRmb3JtOiJsaW51eC9hbWQ2NCJ9Cg==&password-secret=weave-password&trusted-subnets=10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,127.0.0.0/8,169.254.0.0/16&env.KUBERNETES_SERVICE_HOST=127.0.0.1&env.KUBERNETES_SERVICE_PORT=6443&env.IPALLOC_RANGE=10.48.0.0/12"
