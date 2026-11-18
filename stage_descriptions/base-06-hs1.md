Your runner can isolate a local command. In this stage, you'll fetch a public
image from [Docker Hub](https://hub.docker.com/) and execute a command using its
files.

### Images, manifests and layers

An **image** supplies the files a container needs. A registry stores images for
download through the
[Registry HTTP API](https://distribution.github.io/distribution/spec/api/).

An
[image manifest](https://distribution.github.io/distribution/spec/api/#pulling-an-image-manifest)
is a JSON description of an image. Its `layers` array identifies filesystem
archives by **digest**, a content-derived identifier such as a SHA-256 hash. The
layers are listed from base to top. Their combined contents populate the root
directory you already know how to use.

A tag can instead identify a multi-platform index or manifest list. Its
`manifests` array references image manifests for different operating systems and
CPU architectures. Use the image manifest that matches the environment where the
command will execute.

### Registry names and authorization

Docker Hub's HTTPS registry host is `registry.hub.docker.com`.
[Official images](https://docs.docker.com/docker-hub/official_images/) such as
[`alpine:latest`](https://hub.docker.com/_/alpine) and
[`busybox:latest`](https://hub.docker.com/_/busybox) use the `library/`
namespace in API requests. For example, `alpine:latest` means repository
`library/alpine` and tag `latest`. An omitted tag also means `latest`.

Public pulls use
[token authorization](https://distribution.github.io/distribution/spec/auth/token/).
The token grants permission to pull a repository. A `401` response's
`WWW-Authenticate` header supplies the token endpoint's `realm` URL, the
registry's `service` name and the repository access `scope`.

The token endpoint accepts `service` and `scope` as GET query parameters. Its
JSON response contains a `token` or `access_token` value for the
`Authorization: Bearer <token>` request header.

The registry exposes these resources:

| Resource                                                                            | Request path                                 |
| ----------------------------------------------------------------------------------- | -------------------------------------------- |
| Manifest by tag or digest                                                           | `GET /v2/<repository>/manifests/<reference>` |
| [Layer blob](https://distribution.github.io/distribution/spec/api/#pulling-a-layer) | `GET /v2/<repository>/blobs/<digest>`        |

Layer downloads can redirect to another URL. Their contents are tar archives,
often compressed. Applying the layers in manifest order supplies the executable
and its supporting files inside the new root.

{{#lang_is_rust}} The starter's `Cargo.toml` includes
[`reqwest`](https://crates.io/crates/reqwest) for HTTP,
[`serde_json`](https://crates.io/crates/serde_json) for JSON, and `tar` and
`flate2` for archives and decompression. Calling the `tar` command is also an
option for extraction. {{/lang_is_rust}}

{{#lang_is_go}} Go's [`archive/tar`](https://pkg.go.dev/archive/tar) package can
read tar entries. You can also call the `tar` command to extract layers.
{{/lang_is_go}}

{{#lang_is_nim}} Calling the `tar` command is an option for extracting layers.
{{/lang_is_nim}}

{{#lang_is_c}} Calling the `tar` command is an option for extracting layers.
`libcurl` is available in the build environment for HTTP requests.
{{/lang_is_c}}

### Tests

The tester runs commands using files from a downloaded official image. With the
**README**'s local alias, an example is:

```
mydocker run alpine:latest /bin/echo hey
```

The expected stdout is:

```text
hey
```

Preserve the final newline, separate output streams and the command's exit code.
The tester also uses an image name without an explicit tag and inspects the
image's root-directory contents.
