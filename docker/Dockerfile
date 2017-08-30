FROM ubuntu:16.04

# tools
RUN apt-get update && \
	apt-get install -y --no-install-recommends software-properties-common git curl rsync gettext-base nano dnsutils iputils-ping openssh-client make bash-completion bats && \
	apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["bash"]

# ansible
ENV ANSIBLE_VERSION 2.3.2.0
RUN apt-add-repository ppa:ansible/ansible && \
	apt-get update && \
	apt-get install -y --no-install-recommends ansible=${ANSIBLE_VERSION}-1ppa~xenial python-pip python-shade && \
	apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# update pip
RUN pip install --upgrade pip

# ansible lint
RUN pip install ansible-lint==3.4.13

# enable bash autocompletion
RUN echo . /etc/bash_completion >> /root/.bashrc

# cloudflare ssl tools
RUN curl -L -o cfssl     https://pkg.cfssl.org/R1.2/cfssl_linux-amd64     && echo "889d87f6814fbe8d6985713aca35e3be4c632afd cfssl"     | sha1sum -c -
RUN curl -L -o cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && echo "a9766e7eef71a39a5d2ca94061c8a6004fcdd524 cfssljson" | sha1sum -c -
RUN chmod +x cfssl* && mv cfssl* /usr/local/bin
