Your runner can start a child command. In this stage, you'll relay its standard
output and standard error as separate streams.

### Keeping output streams separate

**Standard output** (`stdout`) carries a command's results. **Standard error**
(`stderr`) carries its diagnostics. Callers can capture or redirect each stream
independently.

Forward the child's stdout to your runner's stdout, and its stderr to your
runner's stderr. Preserve the bytes, including newlines. Merging the streams
changes what the caller receives.

Continue executing the supplied local program. The `alpine:latest` argument is
still a placeholder for an image, and image downloads remain deferred.

### Tests

The tester invokes your launcher with commands like this:

```
./your_docker.sh run alpine:latest /usr/local/bin/docker-explorer echo hey
```

The runner's stdout must be exactly:

```text
hey
```

That includes the final newline. The
[`docker-explorer`](https://github.com/codecrafters-io/docker-explorer) helper
also has an `echo_stderr` command:

```
./your_docker.sh run alpine:latest /usr/local/bin/docker-explorer echo_stderr hey
```

This command writes the same `hey` and newline to stderr. The tester varies the
text and checks each stream. Remove your runner's debug logs from both streams
so they do not alter the child's output.

### Notes

- Follow the **README** for local setup. Its `mydocker` alias builds and runs
  your runner in a Docker-based Linux environment, where the required system
  calls are available.
- Within that environment, `docker-explorer --help` shows the helper's commands.
