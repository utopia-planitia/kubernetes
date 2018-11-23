
# netstat -ntup

# until [ $(./network-test.sh | wc -l) -ge 17 ]; do date; time ./update-snapshots.sh; done; ./network-test.sh

BEGIN {
# tcp        0      0 192.168.0.3 57868       192.168.0.3 8081        TIME_WAIT   -
dns_ip="192.168.0.3"
apiserver_ip="10.16.0.1"
}

# from and to internal traffic
($4 ~ "^10\\." || $4 ~ "^127\\." || $4 ~ "^192\\.168\\." || $4 == node_ip) && \
($6 ~ "^10\\." || $6 ~ "^127\\." || $6 ~ "^192\\.168\\." || $6 == node_ip) \
{ next }

# container image builder dockerd
# insecure : raw http & no password
$5 == "2375" || $7 == "2375" { next }	
$5 == "2376" || $7 == "2376" { next }

# accessed via ssh
# mTLS
$5 == "22" { next }

# accessing dns
$7 == "53" { next }
# accessing ntp
$7 == "123" { next }
# accessing http
$7 == "80" { next }
# accessing https
$7 == "443" { next }

# publishing http
$4 ~ cluster_ips && $5 == "80" { next }
# publishing https
$4 ~ cluster_ips && $5 == "443" { next }

# 10254 ingress health
$4 == node_ip && $5 == "10254" && $6 == node_ip { next }
$6 == node_ip && $7 == "10254" { next }

# weave
# shared secret
#$4 == "127.0.0.1" && $5 == "6783" { next } 
#$4 == "127.0.0.1" && $5 == "6784" { next }
$4 == node_ip && $5 == "6783" { next }
$6 ~ cluster_ips && $7 == "6783" { next }

# coredns health
$4 == dns_ip && $5 == "8081" { next }
$6 == dns_ip && $7 == "8081" { next }

#   53 coredns
# 9154 coredns access controlled metrics
# 9153 coredns metrics
$4 == node_ip && $5 == "9153" { next }
$6 == node_ip && $7 == "9153" { next }

# apiserver
# mTLS
$4 ~ node_ip && $5 == "6443" { next }
$6 ~ cluster_ips && $7 == "6443" { next }
$6 == apiserver_ip && $7 == "443" { next }

# api server
# insecure : raw http & no password
# close by setting to 0
#$4 == "127.0.0.1" && $5 == "8080" && $6 == "127.0.0.1" { next }
#$6 == "127.0.0.1" && $7 == "8080" && $4 == "127.0.0.1" { next }

# kube proxy health
$5 == "10249" { next }
$6 == "127.0.0.1" && $7 == "10249" { next }

# 10248 kubelet health
$5 == "10248" { next }
$6 == "127.0.0.1" && $7 == "10248" { next }

# 10250 kubelet operational port
# mTLS
$4 == node_ip && $5 == "10250" { next }
$6 ~ cluster_ips && $7 == "10250" { next }

# 10255 kubelet read only port
# insecure : raw http & no password
# close by setting to 0
# $4 ~ node_ip && $5 == "10255" { next }

# 4194 cadvisor
# insecure : raw http & no password
# should be closed by default
#$4 ~ node_ip && $5 == "4194" { next }

# 10251 scheduler health
$4 == "127.0.0.1" && $5 == "10251" { next }
$6 == "127.0.0.1" && $7 == "10251" { next }
# 10252 contoller manager health
$4 == "127.0.0.1" && $5 == "10252" { next }
$6 == "127.0.0.1" && $7 == "10252" { next }

# 9090 prometheus
# insecure : raw http & no password
$7 == "9090" { next }

# 3000 grafana
# 9093 alert manager
# 9100 node exporter
$4 == node_ip && $5 == "9100" { next }

# 5666 icinga client
# mTLS
$4 ~ node_ip && $5 == "5666" { next }
$6 ~ cluster_ips && $7 == "5666" { next }

# 2379 etcd client
# mTLS
$4 == node_ip && $5 == "2379" { next }
$6 ~ etcd_ips && $7 == "2379" { next }

# 2380 etcd server
# mTLS
$4 == node_ip && $5 == "2380" { next }
$6 ~ etcd_ips && $7 == "2380" { next }

{ print }
