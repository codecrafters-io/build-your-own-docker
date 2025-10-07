You'll now pipe the program's stdout and stderr to the
parent process.

### Tests

The tester will run your program like this:

```
./your_program.sh run alpine:latest /usr/local/bin/docker-explorer echo hey
```

For now, don't worry about pulling the `alpine:latest` image. We will just
execute a local program for this stage and print its output. You'll work on
pulling images from Docker Hub in stage 6.

[docker-explorer](https://github.com/codecrafters-io/docker-explorer) is a custom test program that exposes
commands like `echo` and `ls`.

To test this behaviour locally, you could use the `echo` + `echo_stderr`
commands that `docker-explorer` exposes. Run `docker-explorer --help` to
view usage.

If you've got any logs or print statements in your code, make sure to remove
them. The tester can't differentiate between debug logs and the actual
output!

Note: The **README** in your repository contains setup
information for this stage and beyond (takes < 5 min).
