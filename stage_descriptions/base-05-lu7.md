In the previous stage, we guarded against malicious activity by
restricting an executable's access to the filesystem.

There's another resource that needs to be guarded: the process tree. The
process you're executing is currently capable of viewing all other
processes running on the host system, and sending signals to them.

In this stage, you'll use [PID
namespaces](http://man7.org/linux/man-pages/man7/pid_namespaces.7.html) to
ensure that the program you execute has its own isolated process tree.
The process being executed must see itself as PID 1.

{{#lang_is_php}}
You'll need to use the `pcntl_unshare` function for this, which was
[added in PHP 7.4](https://www.php.net/manual/en/migration74.new-functions.php), and isn't properly documented
yet (as of 22 Jan 2021). Here's the [pull request](https://github.com/php/php-src/pull/3760) where it was added.
{{/lang_is_php}}

Just like the previous stage, the tester will run your program like this:

```
mydocker run alpine:latest /usr/local/bin/docker-explorer mypid
```