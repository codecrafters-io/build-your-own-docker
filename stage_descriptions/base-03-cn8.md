Callers need to know whether a command succeeded. In this stage, you'll return
the child's exit code from your runner.

### Exit status

An **exit code** is the numeric status a process returns when it finishes.
Conventionally, `0` means success and a nonzero value means failure. This status
travels separately from stdout and stderr, so a command can fail without
printing anything.

Your runner must wait for the child to finish and then exit with the same code.
The output forwarding you already implemented remains unchanged.

### Tests

The tester runs commands that exit with different codes. For local testing, the
**README**'s `mydocker` alias accepts the same command arguments:

```
mydocker run alpine:latest /usr/local/bin/docker-explorer exit 1
```

The helper exits with code `1`, so your runner must also exit with code `1`. The
helper's `exit` command does not print the code to either output stream.

### Notes

- `docker-explorer --help` lists the `exit` command's usage.
