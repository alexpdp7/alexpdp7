# Python Modules Primer

## Prerequisites

These instructions assume a Linux environment.
A macOS environment is similar, but not identical.
A Windows environment is more different.

## Previous knowledge

### A refresher on the `PATH` variable

If you execute the following command in your terminal:

```
$ echo hello
```

, the shell searches for the `echo` command in the directories listed in your `PATH` environment variable.
You can display your `PATH` variable by running:

```
$ echo $PATH
/home/user/.local/bin:/home/user/bin:/usr/share/Modules/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin
```

The contents of the `PATH` variable depend on your particular environment.

If you run the following command:

```
$ which echo
/usr/bin/echo
```

The `which` command prints where the shell locates the `echo` command.

### A refresher on shell scripts

If you create a file named `foo.sh` with the following contents:

```
#!/bin/sh

echo hello
```

You define a "shell script".
The first line indicates that this shell script is executed by using the `/bin/sh` command.
The rest of the file are commands to be executed by the shell command.
These commands behave as if you typed them into your terminal, so if you execute this script, the command `echo hello` will be executed, printing `hello`.

If you try to run `foo.sh` like you run the `echo` command, by typing its name, it does not work:

```
$ foo.sh
bash: foo.sh: command not found...
```

, because the shell looks for the `foo.sh` in the directories listed in the `PATH` variable.
Unless you created the `foo.sh` file in a directory like `/usr/bin`, the shell will not find the `foo.sh` command.

A solution to this problem is to specify the path to the `foo.sh` file, instead of relying on the `PATH` variable.
However, if you do this, you face a second problem.

```
$ ./foo.sh
bash: ./foo.sh: Permission denied
```

This happens because only files with the executable permission can be executed in this way.
To solve this, add the executable permission; then it works:

```
$ chmod +x foo.sh
$ ./foo.sh
hello
```
