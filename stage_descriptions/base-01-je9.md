A container runner needs to start a program before it can isolate that program.
In this stage, you'll execute a local command through your runner.

### Starting a child process

A **process** is a running program. Your runner starts the requested command as
a **child process**. The runner is that child's parent.

Your command-line interface follows the shape of
[`docker run`](https://docs.docker.com/engine/reference/run/):

```text
run <image> <command> [args...]
```

The `<image>` argument names a package of files for running programs. For now,
the command already exists in the test environment, so image downloads and
isolation are deferred. `<command>` is the executable's path, and all following
arguments belong to that executable.

### Tests

The tester invokes your launcher with arguments like these:

```
./your_docker.sh run alpine:latest /usr/local/bin/docker-explorer echo hey
```

[`docker-explorer`](https://github.com/codecrafters-io/docker-explorer) is a
supplied test program. Its `echo` command prints the arguments that follow it.

Run the requested command and return its output through your runner's standard
output. For this example, that output must contain:

```text
hey
```

The tester varies the echoed text. This stage checks that the child's output
appears, while exact output handling comes later.

### Notes

- The starter includes code for launching the command. Your repository's
  **README** explains the Docker-based environment for local testing.
