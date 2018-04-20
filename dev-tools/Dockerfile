FROM ubuntu:17.10

# tools
RUN apt-get update && \
	apt-get install -y \
		software-properties-common \
		python-pip \
		git \
		curl \
		rsync \
		gettext-base \
		nano dnsutils \
		iputils-ping \
		openssh-client \
		make \
		bash-completion \
		apache2-utils \
		bats && \
	apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["bash"]

# ansible
ENV ANSIBLE_VERSION 2.5.1
RUN pip install ansible==${ANSIBLE_VERSION}

# ansible lint
RUN pip install ansible-lint

# ansible digital ocean lib
RUN pip install dopy

# enable bash autocompletion
RUN echo . /etc/bash_completion >> /root/.bashrc

# golang
ENV GOPATH /go
ENV GOROOT /usr/lib/go-1.9
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH
RUN add-apt-repository ppa:gophers/archive && \
	apt-get update && \
	apt-get install -y \
		golang-1.9-go && \
	apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# cloudflare ssl tools
RUN curl -s -L -o /usr/local/bin/cfssl		https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
	chmod +x /usr/local/bin/cfssl && \
	curl -s -L -o /usr/local/bin/cfssljson	https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
	chmod +x /usr/local/bin/cfssljson

# kubernetes
ENV KUBERNETES_VERSION v1.10.1
ENV KUBERNETES_CONFORMANCE_TEST=y
RUN go get -u github.com/jteeuwen/go-bindata/go-bindata && \
	go get -u k8s.io/test-infra/kubetest && \
	mkdir -p /go/src/k8s.io && \
    git clone --depth 1 -b ${KUBERNETES_VERSION} https://github.com/kubernetes/kubernetes.git /go/src/k8s.io/kubernetes && \
	cd /go/src/k8s.io/kubernetes && \
	make all WHAT=cmd/kubectl && \
    make all WHAT=vendor/github.com/onsi/ginkgo/ginkgo && \
    make all WHAT=test/e2e/e2e.test && \
	rm -rf /go/pkg && \
	rm -rf /go/src/github.com && \
	rm -rf /go/src/k8s.io/test-infra && \
	rm -rf /go/src/k8s.io/kubernetes/.git && \
	rm -rf /go/src/k8s.io/kubernetes/_output/local/go && \
	ln -s /go/src/k8s.io/kubernetes/_output/local/bin/linux/amd64/kubectl /usr/local/bin/kubectl && \
	echo "source <(kubectl completion bash)" >> ~/.bashrc
