FROM swift:5.6.1-focal

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl=7.68.* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download docker-explorer
ARG docker_explorer_version=v18
RUN curl --fail -Lo /usr/local/bin/docker-explorer https://github.com/codecrafters-io/docker-explorer/releases/download/${docker_explorer_version}/${docker_explorer_version}_linux_amd64
RUN chmod +x /usr/local/bin/docker-explorer
