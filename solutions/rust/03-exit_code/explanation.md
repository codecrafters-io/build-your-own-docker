
Checking the [documentation](https://doc.rust-lang.org/std/process/struct.Child.html#method.wait) for the `Child` type's `wait` function
we find that it gives us an `ExitCode`. Following that [down](https://doc.rust-lang.org/std/process/struct.ExitStatus.html#method.code, 
we find there is a `code` function on that type which gives us the child process's exit code.

```rust
let exit_code = child.wait()?.code().unwrap_or(1);
exit(exit_code);
```

The documentation also tells us that when the child process is killed by signal (e.g. Ctrl+C) we won't get
an exit code. So in the case that `code()` returns `None` we provide a default value of 1 using `unwrap_or()`.
