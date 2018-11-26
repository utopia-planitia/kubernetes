
# netstat -ntup

# until [ $(./network-test.sh | wc -l) -ge 17 ]; do date; time ./update-snapshots.sh; done; ./network-test.sh

BEGIN {
# tcp        0      0 192.168.0.3 57868       192.168.0.3 8081        TIME_WAIT   -
dns_ip="192.168.0.3"
}

## icinga ntp in sync check
#($1 == "udp" || $1 == "udp6") && \
#$4 == "0.0.0.0" && $5 >= 32769 && $5 <= 65535 && \
#$6 == "0.0.0.0" && $7 == "*" && \
#$8 ~ /_ntp_/ \
#{ next }
## icinga dhcp check
#($1 == "udp" || $1 == "udp6") && \
#$4 == "0.0.0.0" && $5 == 68 && \
#$6 == "0.0.0.0" && $7 == "*" && \
#$8 ~ /_dhcp$/ \
#{ next }

# container image builder dockerd
# insecure : raw http & no password
$4 == "0.0.0.0" && $5 == "2375" { next }
$4 == "127.0.0.1" && $5 == "2376" { next }

# publishing ssh
# mTLS
$4 == "0.0.0.0" && $5 == "22" { next }
# publishing http
# should be public
$4 == "0.0.0.0" && $5 == "80" { next }
# publishing https
# should be public
$4 == "0.0.0.0" && $5 == "443" { next }
# 10254 ingress health
# insecure : raw http & no password
$4 == "0.0.0.0" && $5 == "10254" { next }
# 18080 ingress nginx
# insecure : raw http & no password
$4 == "0.0.0.0" && $5 == "18080" { next }

# 6783 weave internode port
# shared secret
$5 == "6783" { next }
# 6784 weave management port
# insecure : raw http & no password
$4 == "127.0.0.1" && $5 == "6784" { next }
# 6782 weave metrics
# insecure : raw http & no password
$5 == "6782" { next }
# 6781 network policy controller, metrics?
# insecure : raw http & no password
$5 == "6781" { next }

# 8081 coredns health
# insecure : raw http & no password
$4 == dns_ip && $5 == "8081" { next }
#   53 coredns dns
# insecure : raw dns
$4 == dns_ip && $5 == "53" { next }
# 9154 coredns metrics
# insecure : raw http & no password
$4 == dns_ip && $5 == "9154" { next }
# 9153 coredns metrics access controlled
# insecure : raw http & no password
$4 == "0.0.0.0" && $5 == "9153" { next }

## apiserver
## mTLS
$4 == "0.0.0.0" && $5 == "6443" { next }

# api server
# insecure : raw http & no password
$4 == "127.0.0.1" && $5 == "8080" { next }

# 10256 kube proxy health
# insecure : raw http & no password
$4 == "0.0.0.0" && $5 == "10256" { next }

# 10249 kube proxy metrics
# insecure : raw http & no password
$4 == "127.0.0.1" && $5 == "10249" { next }

# 10248 kubelet health
# insecure : raw http & no password
$4 == "127.0.0.1" && $5 == "10248" { next }

# 10250 kubelet operational port
# mTLS
$4 == "0.0.0.0" && $5 == "10250" { next }

# ??? random kubelet port
# insecure : raw http & no password & unknown use
$4 == "127.0.0.1" && $5 >= 32769 && $5 <= 46883 && $9 ~ /\/kubelet$/ { next }

# 10255 kubelet read only port
# insecure : raw http & no password
# close by setting to 0
$4 == "0.0.0.0" && $5 == "10255" { print }

# 4194 cadvisor
# insecure : raw http & no password
# should be closed by default
$4 == "0.0.0.0" && $5 == "4194" { print }

# 10251 scheduler health
# insecure : raw http & no password
$4 == "127.0.0.1" && $5 == "10251" { next }
# 10252 contoller manager health
# insecure : raw http & no password
$4 == "127.0.0.1" && $5 == "10252" { next }

# 9090 prometheus
# 30900 prometheus node port
# insecure : raw http & no password
$4 == "0.0.0.0" && $5 == "30900" { next }

# 3000 grafana
# 30902 grafana node port
# insecure : raw http & no password
$4 == "0.0.0.0" && $5 == "30902" { next }

## 9093 alert manager
## 30903 alert manager node port
# insecure : raw http & no password
$4 == "0.0.0.0" && $5 == "30903" { next }

# 9100 node exporter
# insecure : raw http & no password
$4 == "0.0.0.0" && $5 == "9100" { next }

## 5666 icinga client
## mTLS
$4 == "0.0.0.0" && $5 == "5666" { next }

## 2379 etcd client
## mTLS
$4 == "0.0.0.0" && $5 == "2379" { next }

## 2380 etcd server
## mTLS
$4 == "0.0.0.0" && $5 == "2380" { next }

{ print }
