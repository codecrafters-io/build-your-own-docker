use std::env::args;
use std::process::{Command, exit, Stdio};
use anyhow::{Context, Result};

// Usage: your_docker.sh run <image> <command> <arg1> <arg2> ...
fn main() -> Result<()> {
    let args: Vec<_> = args().collect();
    let command = &args[3];
    let command_args = &args[4..];
    let mut child = Command::new(command)
        .args(command_args)
        .stdin(Stdio::null())
        .spawn()
        .with_context(|| {
            format!(
                "Tried to run '{}' with arguments {:?}",
                command, command_args
            )
        })?;

    // The code is not available when terminated by signal so use 1
    let exit_code = child.wait()?.code().unwrap_or(1);
    exit(exit_code);
}
