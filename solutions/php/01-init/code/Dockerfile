FROM php:7.4-cli-alpine

RUN apk add --no-cache --upgrade 'curl>=7.66'
RUN apk add --no-cache --upgrade 'curl-dev>=7.66'

RUN docker-php-ext-install pcntl

# Download docker-explorer.
ARG docker_explorer_version=v18
RUN curl --fail -Lo /usr/local/bin/docker-explorer https://github.com/codecrafters-io/docker-explorer/releases/download/${docker_explorer_version}/${docker_explorer_version}_linux_amd64
RUN chmod +x /usr/local/bin/docker-explorer

COPY . /app
WORKDIR /app

RUN sed -i -e 's/\r$//' /app/your_docker.sh

ENTRYPOINT ["/app/your_docker.sh"]
