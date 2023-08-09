FROM python:3.11-alpine

RUN apk add curl

# Download docker-explorer
ARG docker_explorer_version=v18
RUN curl -Lo /usr/local/bin/docker-explorer https://github.com/codecrafters-io/docker-explorer/releases/download/${docker_explorer_version}/${docker_explorer_version}_linux_amd64
RUN chmod +x /usr/local/bin/docker-explorer

ADD . /app
WORKDIR /app

RUN sed -i -e 's/\r$//' /app/your_docker.sh

ENTRYPOINT ["/app/your_docker.sh"]
