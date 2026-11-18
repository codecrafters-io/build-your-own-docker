The child now has its own filesystem root. In this stage, you'll run it in a new
PID namespace, where it sees itself as PID `1`.

### Process IDs and namespaces

A **process ID**, or **PID**, identifies a running process. A
[PID namespace](http://man7.org/linux/man-pages/man7/pid_namespaces.7.html)
gives processes their own set of IDs. Processes use these IDs to address other
processes in the same namespace or its descendants.

The first process created in a new PID namespace has PID `1` there. The host
still sees that process under a PID in the host's namespace. The command you
execute must be the process that sees itself as PID `1`.

Linux's `CLONE_NEWPID` flag requests a new PID namespace. With `unshare`, it
affects children created after the call. The calling process keeps its existing
PID namespace. This distinction matters when placing the child command in the
new namespace.

Keep the filesystem isolation, output forwarding and exit-status behavior you
already implemented. PID namespaces control process-ID visibility, while
`chroot` controls the filesystem root.

{{#lang_is_php}} PHP's
[`pcntl_unshare`](https://www.php.net/manual/en/function.pcntl-unshare.php),
[added in PHP 7.4](https://www.php.net/manual/en/migration74.new-functions.php),
accepts `CLONE_NEWPID`. The
[original pcntl_unshare change](https://github.com/php/php-src/pull/3760)
documents its introduction. {{/lang_is_php}}

### Tests

The tester runs `docker-explorer mypid`, which reports the helper process's own
PID. Using the **README**'s local alias:

```
mydocker run alpine:latest /usr/local/bin/docker-explorer mypid
```

Your runner's stdout must be exactly this value followed by a newline:

```text
1
```
