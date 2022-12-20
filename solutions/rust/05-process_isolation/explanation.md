This step requires us to call a C function to set a flag for our process. 
Check the [documentation](https://man7.org/linux/man-pages/man2/unshare.2.html) for the `unshare` function.

The new code does a couple of things. First it checks that the code is running on Linux. If not, we wouldn't have the
`unshare` function. Then it tells the Rust compiler that we want to write unsafe code. Inside this block there are fewer
guarantees given by the compiler.
Finally, we can call the `unshare` function using the wrapper provided by the Rust `libc` crate.

```rust
if cfg!(target_os = "linux") {
    unsafe {
        libc::unshare(libc::CLONE_NEWPID);
    }
}
```

Now that this flag is set, when we launch a new child process it will start in a new process ID namespace.
