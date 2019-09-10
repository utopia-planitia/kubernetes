# reg build
FROM golang:1.12.6-alpine3.10 AS reg
RUN apk --no-cache add git
RUN GOOS=linux GARCH=amd64 CGO_ENABLED=0 go get github.com/genuinetools/reg

FROM ubuntu:18.04

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
		sshpass \
		make \
		bash-completion \
		apache2-utils \
		bsdmainutils \
		bats \
		libmnl0 \
		dkms && \
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

# cloudflare ssl tools
RUN curl -s -L -o /usr/local/bin/cfssl		https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
	chmod +x /usr/local/bin/cfssl && \
	curl -s -L -o /usr/local/bin/cfssljson	https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
	chmod +x /usr/local/bin/cfssljson

# wireguard
COPY roles/wireguard/files /tmp/wireguard
RUN dpkg -i /tmp/wireguard/wireguard-tools_0.0.20190227-wg1~bionic_amd64.deb
RUN dpkg -i /tmp/wireguard/wireguard-dkms_0.0.20190227-wg1~bionic_all.deb
RUN dpkg -i /tmp/wireguard/wireguard_0.0.20190227-wg1~bionic_all.deb

# kubectl
ENV KUBERNETES_VERSION v1.13.5
RUN curl -s -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl && \
	chmod +x /usr/local/bin/kubectl && \
	echo "source <(kubectl completion bash)" >> ~/.bashrc

# krew
RUN ( \
  set -x; cd "$(mktemp -d)" && \
  curl -fsSLO "https://storage.googleapis.com/krew/v0.2.1/krew.{tar.gz,yaml}" && \
  tar zxvf krew.tar.gz && \
  ./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" install --manifest=krew.yaml --archive=krew.tar.gz \
)
ENV PATH="/root/.krew/bin:$PATH"
RUN kubectl krew install get-all

# kubectx & kubens
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
	cd /opt/kubectx && git checkout v0.6.3 && \
	mv /opt/kubectx/kubectx /usr/local/bin/kubectx && \
	mv /opt/kubectx/kubens /usr/local/bin/kubens && \
	rm -r /opt/kubectx

# helm
RUN curl -L --fail -o helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.14.1-linux-amd64.tar.gz && \
    tar zxv -C /tmp -f helm.tar.gz && \
    rm -f helm.tar.gz && \
	mv /tmp/linux-amd64/helm /usr/local/bin/ && \
	mv /tmp/linux-amd64/tiller /usr/local/bin/ && \
	rm -rf /tmp/linux-amd64

# helm plugins
RUN helm init --client-only
RUN helm plugin install https://github.com/databus23/helm-diff --version 2.11.0+5

# helmfile
RUN curl -L --fail https://github.com/roboll/helmfile/releases/download/v0.77.0/helmfile_linux_amd64 -o /usr/local/bin/helmfile && \
	chmod +x /usr/local/bin/helmfile

# kustomize
RUN curl -L --fail https://github.com/kubernetes-sigs/kustomize/releases/download/v2.1.0/kustomize_2.1.0_linux_amd64 -o /usr/local/bin/kustomize && \
	chmod +x /usr/local/bin/kustomize

# yq
RUN pip install yq

# jq
RUN curl -L --silent --fail -o /usr/local/bin/jq \
    https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x /usr/local/bin/jq

# reg
COPY --from=reg /go/bin/reg /usr/local/bin/reg

# lab
RUN curl -L --silent --fail https://raw.githubusercontent.com/zaquestion/lab/master/install.sh | bash
