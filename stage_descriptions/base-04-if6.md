The child currently resolves paths in the runner's filesystem. In this stage,
you'll give it a dedicated filesystem root using
[chroot](https://en.wikipedia.org/wiki/Chroot).

### Changing the filesystem root

A process resolves absolute paths from its root directory, `/`. `chroot` changes
that root, and child processes inherit it. Use an initially empty temporary
directory as the new root, with a copy of the executable at the path the command
expects.

For example, if the new root is `/tmp/container-root`, the child's
`/usr/local/bin/docker-explorer` refers to
`/tmp/container-root/usr/local/bin/docker-explorer` in the runner's original
filesystem.

`chroot` leaves the current working directory unchanged. The launched command's
working directory must also be inside the new root.

{{#lang_is_rust}} Rust provides
[`std::os::unix::fs::chroot`](https://doc.rust-lang.org/std/os/unix/fs/fn.chroot.html)
for changing the root. The starter also includes
[`libc`](https://crates.io/crates/libc) for direct system-call bindings.
{{/lang_is_rust}}

{{#lang_is_nim}} The starter's Nim version does not expose `chroot` in its
[`posix` module](https://nim-lang.org/docs/posix.html). You can declare a
binding to the system call using the module's
[`chdir` declaration](https://nim-lang.org/docs/posix.html#chdir%2Ccstring) as a
reference. {{/lang_is_nim}}

{{#lang_is_go}} Go's [`Cmd.Run()`](https://golang.org/pkg/os/exec/#Cmd.Run) and
related methods use `/dev/null` for unconnected streams. A fresh root lacks that
path, which can cause `open /dev/null: no such file or directory`. For these
test commands, an empty `/dev/null` file inside the new root can stand in for
unused input. Alternatively, connect `Cmd.Stdout`, `Cmd.Stderr` and `Cmd.Stdin`
so none is `nil`. See the
[Go subprocess /dev/null explanation](https://rohitpaulk.com/articles/cmd-run-dev-null).
{{/lang_is_go}}

{{#lang_is_rust}} Rust's
[`Command::output()`](https://doc.rust-lang.org/std/process/struct.Command.html#method.output)
uses `/dev/null` for the child's unused input. A missing `/dev/null` can cause
`no such file or directory` even when the executable exists. An empty file at
that path inside the new root is sufficient for these test commands. The
[subprocess /dev/null explanation](https://rohitpaulk.com/articles/cmd-run-dev-null)
describes this failure. {{/lang_is_rust}}

### Tests

The tester creates a directory outside the new root and asks the child to list
it. A corresponding local invocation is:

```
mydocker run alpine:latest /usr/local/bin/docker-explorer ls /some_dir
```

The directory must be inaccessible through that path inside the new root. The
test helper reports this on stdout:

```text
No such file or directory
```

It exits with code `2`. Preserve both that output and the exit code through your
runner.

### Notes

- Use the **README**'s Docker-based local setup for the required Linux
  privileges.
- Use trusted commands while developing this runner. `chroot` alone does not
  provide a security boundary against hostile code.
