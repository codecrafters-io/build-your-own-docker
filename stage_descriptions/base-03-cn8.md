In this stage, you'll need to relay the program's exit code to the parent
process.

If the program you're executing exits with exit code 1, your program
should exit with exit code 1 too.

To test this behaviour locally, you could use the `exit` command that
`docker-explorer` exposes. Run `docker-explorer --help` to view usage.

Just like the previous stage, the tester will run your program like this:

```
mydocker run alpine:latest /usr/local/bin/docker-explorer exit 1
```