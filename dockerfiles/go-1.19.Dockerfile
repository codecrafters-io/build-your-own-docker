FROM golang:1.19-alpine

RUN apk add curl

# Download docker-explorer
ARG docker_explorer_version=v18
RUN curl --fail -Lo /usr/local/bin/docker-explorer https://github.com/codecrafters-io/docker-explorer/releases/download/${docker_explorer_version}/${docker_explorer_version}_linux_amd64
RUN chmod +x /usr/local/bin/docker-explorer

ENV CODECRAFTERS_DEPENDENCY_FILE_PATHS="go.mod,go.sum"

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod graph | awk '{if ($1 !~ "@") print $2}' | xargs -r go get

