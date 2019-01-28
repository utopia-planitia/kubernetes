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

# cloudflare ssl tools
RUN curl -s -L -o /usr/local/bin/cfssl		https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
	chmod +x /usr/local/bin/cfssl && \
	curl -s -L -o /usr/local/bin/cfssljson	https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
	chmod +x /usr/local/bin/cfssljson

# wireguard
RUN add-apt-repository ppa:wireguard/wireguard && \
    apt-get update && \
	apt-get install -y \
		wireguard=0.0.20190123-wg1~bionic && \
	apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# kubectl
ENV KUBERNETES_VERSION v1.13.2
RUN curl -s -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl && \
	chmod +x /usr/local/bin/kubectl && \
	echo "source <(kubectl completion bash)" >> ~/.bashrc
