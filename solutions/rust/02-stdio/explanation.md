Checking the [documentation](https://doc.rust-lang.org/std/process/struct.Command.html#method.spawn) for `Command` we find the `spawn` function which can be used
to start the command and inherit the parent's input and output streams.

We will ignore stdin because we don't need it and use `spawn` to inherit stdin/stdout from the current program.

```rust
Command::new(command)
    // ...
    .stdin(Stdio::null())
    .spawn()
    // ...
```

Now that we don't need to access the stdout/stderr of the child process, we can just wait for it to finish

```rust
child.wait()?;
```
