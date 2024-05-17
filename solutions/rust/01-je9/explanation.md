The entry point for your Docker implementation is in `src/main.rs`.

Study and uncomment the relevant code: 

```rust
// Uncomment this block to pass the first stage!
let args: Vec<_> = std::env::args().collect();
let command = &args[3];
let command_args = &args[4..];
let output = std::process::Command::new(command)
    .args(command_args)
    .output()
    .with_context(|| {
        format!(
            "Tried to run '{}' with arguments {:?}",
            command, command_args
        )
    })?;

if output.status.success() {
    let std_out = std::str::from_utf8(&output.stdout)?;
    println!("{}", std_out);
} else {
    std::process::exit(1);
}
```

Push your changes to pass the first stage:

```
git add .
git commit -m "pass 1st stage" # any msg
git push origin master
```
