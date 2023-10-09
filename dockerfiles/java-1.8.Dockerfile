FROM maven:3.9.4-eclipse-temurin-8-alpine

RUN apk add curl

# Download docker-explorer
ARG docker_explorer_version=v18
RUN curl --fail -Lo /usr/local/bin/docker-explorer https://github.com/codecrafters-io/docker-explorer/releases/download/${docker_explorer_version}/${docker_explorer_version}_linux_amd64
RUN chmod +x /usr/local/bin/docker-explorer

COPY pom.xml /app/pom.xml

WORKDIR /app

# Download dependencies
RUN mvn -B package -Ddir=/tmp/codecrafters-docker-target

# Cache dependencies
RUN mkdir -p /app-cached
RUN mv /app/target /app-cached

# Pre-compile steps
RUN echo "cd \${CODECRAFTERS_SUBMISSION_DIR} && mvn -B package -Ddir=/tmp/codecrafters-docker-target && sed -i 's/^\(mvn .*\)/#\1/' ./your_docker.sh" > /codecrafters-precompile.sh
RUN chmod +x /codecrafters-precompile.sh