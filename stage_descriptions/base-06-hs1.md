Your docker implementation can now execute a program with a fair degree of
isolation - it can't modify files or interact with processes running on
the host.

In this stage, you'll use [the Docker registry
API](https://docs.docker.com/registry/spec/api/) to fetch the contents of
a public image on [Docker Hub](https://hub.docker.com/) and then execute a
command within it.

You'll need to:

- Do a small [authentication dance](https://docs.docker.com/registry/spec/auth/token/)
- Fetch the [image manifest](https://docs.docker.com/registry/spec/api/#pulling-an-image-manifest)
- [Pull layers](https://docs.docker.com/registry/spec/api/#pulling-a-layer) of an image and extract them to the chroot directory

The base URL for Docker Hub's public registry is `registry.hub.docker.com`.

The tester will run your program like this:

```
mydocker run alpine:latest /bin/echo hey
```

The image used will be an [official
image](https://docs.docker.com/docker-hub/official_images/) from Docker
Hub. For example: [`alpine:latest`](https://hub.docker.com/_/alpine),
[`alpine:latest`](https://hub.docker.com/_/alpine),
[`busybox:latest`](https://hub.docker.com/_/busybox). When interacting with the
Registry API, you'll need to prepend `library/` to the image names.

{{#lang_is_rust}}
Since Rust doesn't have an archive extraction utility in its stdlib, you
might want to shell out and use `tar`.

You can use the [reqwest](https://crates.io/crates/reqwest) crate to make
HTTP requests, we've included it in the `Cargo.toml` file. We've also included
[serde_json](https://crates.io/crates/serde_json) to help with parsing JSON.
{{/lang_is_rust}}

{{#lang_is_go}}
Since Go doesn't have an archive extraction utility in its stdlib, you
might want to shell out and use `tar`.
{{/lang_is_go}}

{{#lang_is_nim}}
Since Nim doesn't have an archive extraction utility in its stdlib, you
might want to shell out and use `tar`.
{{/lang_is_nim}}

{{#lang_is_c}}
Since C doesn't have an archive extraction utility in its stdlib, you
might want to shell out and use `tar`.

You can assume that `libcurl` is available in the build environment.
{{/lang_is_c}}