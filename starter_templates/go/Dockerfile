FROM golang:1.22-alpine

RUN apk add --no-cache 'curl>=7.66'

# Download docker-explorer
ARG docker_explorer_version=v18
RUN curl -Lo /usr/local/bin/docker-explorer https://github.com/codecrafters-io/docker-explorer/releases/download/${docker_explorer_version}/${docker_explorer_version}_linux_amd64
RUN chmod +x /usr/local/bin/docker-explorer

COPY . /app
WORKDIR /app

RUN sed -i -e 's/\r$//' /app/your_docker.sh

ENTRYPOINT ["/app/your_docker.sh"]
