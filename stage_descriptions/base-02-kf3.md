You'll now pipe the program's stdout and stderr to the
parent process.

Like the last stage, the tester will run your program like this:

```
mydocker run alpine:latest /usr/local/bin/docker-explorer echo hey
```

To test this behaviour locally, you could use the `echo` + `echo_stderr`
commands that `docker-explorer` exposes. Run `docker-explorer --help` to
view usage.

If you've got any logs or print statements in your code, make sure to remove
them. The tester can't differentiate between debug logs and the actual
output!

Note: The **README** in your repository contains setup
information for this stage and beyond (takes < 5 min).