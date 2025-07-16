Your task is to implement a very basic version
of [`docker run`](https://docs.docker.com/engine/reference/run/)</a>. It will
be executed similar to `docker run`:

```
mydocker run alpine:latest /usr/local/bin/docker-explorer echo hey
```

[docker-explorer](https://github.com/codecrafters-io/docker-explorer) is a custom test program that exposes
commands like `echo` and `ls`.

For now, don't worry about pulling the `alpine:latest` image. We will just
execute a local program for this stage and print its output. You'll work on
pulling images from Docker Hub in stage 6.