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
