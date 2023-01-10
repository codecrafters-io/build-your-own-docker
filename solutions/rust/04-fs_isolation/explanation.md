
There are a few steps to setting up a working directory for `chroot`.

We need a directory to work in, which we'll create using `let temp_dir = tempfile::tempdir()?;`. 
This needs to go out of scope to be cleaned up, so we refactor to a function called `run_child` 
so that the temp_dir is cleaned up before we call `exit` in `main`. See the library [documentation](https://docs.rs/tempfile/latest/tempfile/struct.TempDir.html#resource-leaking).

Now we need to move anything that our child program will need into this new directory. This is the child program itself
and `/dev/null`. See the course notes for this section which explains why `dev/null` is required.

Copy the command with

```rust
fn copy_command(command: &String, temp_dir: &TempDir) -> Result<()> {
    let command_path_relative = command.trim_start_matches("/");
    let target_command = temp_dir.path().join(command_path_relative);
    let target_path = target_command.parent().unwrap();
    create_dir_all(target_path)?;
    copy(command, target_command)?;

    Ok(())
}
```

The `copy` function will retain file permissions, so we don't have to change permissions for the target binary.

```rust
fn create_dev_null(temp_dir: &TempDir) -> Result<()> {
    create_dir(temp_dir.path().join("dev"))?;
    set_permissions(temp_dir.path().join("dev"), Permissions::from_mode(0o555))?;
    File::create(temp_dir.path().join("dev/null"))?;
    set_permissions(temp_dir.path().join("dev/null"), Permissions::from_mode(0o555))?;

    Ok(())
}
```

Here the directory/file permissions will not default to what we want, so we set them to be the same as the system /dev/null. 

That's all the setup, and we can do the `chroot`. You can find the documentation [here](https://doc.rust-lang.org/std/os/unix/fs/fn.chroot.html).

```rust
fn change_root(temp_dir: TempDir) -> Result<()> {
    chroot(temp_dir.path())?;

    // Move working directory to the new root at the chroot dir
    set_current_dir("/")?;

    Ok(())
}
```

Our program and child processes we launch can only access the directories/files inside the new temp directory. We launch
the child command exactly as we did before.
