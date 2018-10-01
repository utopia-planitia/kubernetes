FROM gcr.io/heptio-images/kube-conformance:v1.12.1

RUN apt-get update && \
	apt-get install -y \
		make && \
	apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV E2E_PARALLEL y
COPY run_e2e.sh /run_e2e.sh
