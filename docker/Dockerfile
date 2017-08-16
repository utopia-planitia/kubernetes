FROM ubuntu:16.04

# tools
RUN apt-get update && \
	apt-get install -y software-properties-common git curl rsync gettext-base nano dnsutils iputils-ping && \
	apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["bash"]

# ansible
ENV ANSIBLE_VERSION 2.3.2.0
RUN apt-add-repository ppa:ansible/ansible && \
	apt-get update && \
	apt-get install -y ansible=${ANSIBLE_VERSION}-1ppa~xenial python-pip rsync && \
	apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
