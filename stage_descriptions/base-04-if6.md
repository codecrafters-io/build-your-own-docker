In the previous stage, we executed a program that existed locally on our
machine. This program had write access to the whole filesystem, which
means that it could do **dangerous** things!

In this stage, you'll use [chroot](https://en.wikipedia.org/wiki/Chroot)
to ensure that the program you execute doesn't have access to any files on
the host machine. Create an empty temporary directory and `chroot` into it
when executing the command. You'll need to copy the binary being executed
too.

{{#lang_is_rust}}
At the time of writing this, the implementation of chroot in Rust's standard library
([std::os::unix::fs::chroot](https://doc.rust-lang.org/std/os/unix/fs/fn.chroot.html)) is still a
nightly-only experimental API. We've included [libc](https://crates.io/crates/libc) as a dependency
instead.
{{/lang_is_rust}}

{{#lang_is_nim}}
Since Nim's [posix module](https://nim-lang.org/docs/posix.html) doesn't
have `chroot` defined, you'll need to implement this yourself! For
examples on how to do this, view the source for other syscalls like
[chdir](https://nim-lang.org/docs/posix.html#chdir%2Ccstring).
{{/lang_is_nim}}

{{#lang_is_go}}
When executing your program within the chroot directory, you might run into an error that says
`open /dev/null: no such file or directory`. This is because [Cmd.Run()](https://golang.org/pkg/os/exec/#Cmd.Run)
and its siblings expect `/dev/null` to be present. You can work around this by either creating an empty
`/dev/null` file inside the chroot directory, or by ensuring that `Cmd.Stdout`, `Cmd.Stderr` and `Cmd.Stdin` are not `nil`.
More details about this [here](https://rohitpaulk.com/articles/cmd-run-dev-null).
{{/lang_is_go}}

{{#lang_is_rust}}
When executing your program within the chroot directory, you might run into an error that says
`no such file or directory` even if the binary exists within the chroot. This is because
[Command::output()](https://doc.rust-lang.org/std/process/struct.Command.html#method.output)
expects `/dev/null` to be present. You can work around this by creating an empty
`/dev/null` file inside the chroot directory. This cryptic error effects Go programs too, more details
[here](https://rohitpaulk.com/articles/cmd-run-dev-null).
{{/lang_is_rust}}

Just like the previous stage, the tester will run your program like this:

```
mydocker run alpine:latest /usr/local/bin/docker-explorer ls /some_dir
```