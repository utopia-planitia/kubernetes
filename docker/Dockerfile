FROM ubuntu:16.04

# tools
RUN apt-get update && \
	apt-get install -y software-properties-common git curl rsync gettext-base nano dnsutils iputils-ping && \
	apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["bash"]
