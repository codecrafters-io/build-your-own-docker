# syntax=docker/dockerfile:1.7-labs
FROM rust:1.62-buster

# Download docker-explorer
ARG docker_explorer_version=v18
RUN curl --fail -Lo /usr/local/bin/docker-explorer https://github.com/codecrafters-io/docker-explorer/releases/download/${docker_explorer_version}/${docker_explorer_version}_linux_amd64
RUN chmod +x /usr/local/bin/docker-explorer


RUN mkdir /app/src
RUN echo 'fn main() { println!("Hello World!"); }' > /app/src/main.rs

WORKDIR /app
# .git & README.md are unique per-repository. We ignore them on first copy to prevent cache misses
COPY --exclude=.git --exclude=README.md . /app
RUN cargo build --release --target-dir=/tmp/codecrafters-docker-target

RUN cargo clean -p docker-starter-rust --release --target-dir=/tmp/codecrafters-docker-target

RUN rm -rf /app/src

RUN echo "cd \${CODECRAFTERS_SUBMISSION_DIR} && cargo build --release --target-dir=/tmp/codecrafters-docker-target --manifest-path Cargo.toml" > /codecrafters-precompile.sh
RUN chmod +x /codecrafters-precompile.sh

ENV CODECRAFTERS_DEPENDENCY_FILE_PATHS="Cargo.toml,Cargo.lock"


# Once the heave steps are done, we can copy all files back
COPY . /app
