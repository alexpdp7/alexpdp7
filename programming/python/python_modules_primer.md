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

## The `import` statement in Python

### Importing from the Python standard library

Run the following commands by using the Python REPL:

```
$ python3
Python 3.9.17 (main, Aug  9 2023, 00:00:00)
[GCC 11.4.1 20230605 (Red Hat 11.4.1-2)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import datetime
>>> datetime.datetime.now()
datetime.datetime(2023, 9, 11, 21, 53, 16, 331236)
```

`import` works in a similar way to running a command in the shell.
Python searches a number of directories looking for the `datetime` module.

To see which directories are searched, run:

```
$ python3
>>> import sys
>>> sys.path
['', '/usr/lib64/python39.zip', '/usr/lib64/python3.9', '/usr/lib64/python3.9/lib-dynload', '/home/alex/.local/lib/python3.9/site-packages', '/usr/lib64/python3.9/site-packages', '/usr/lib/python3.9/site-packages']
```

`sys.path` is a list of the directories that the `import` command searches.
The contents of `sys.path` depend on your operating system and Python installation method.

In my system, the `/usr/lib64/python3.9` directory contains the `datetime.py` module.

```
$ head /usr/lib64/python3.9/datetime.py
"""Concrete date/time and related types.

See http://www.iana.org/time-zones/repository/tz-link.html for
time zone and DST data sources.
"""

__all__ = ("date", "datetime", "time", "timedelta", "timezone", "tzinfo",
           "MINYEAR", "MAXYEAR")
...
```

`/usr/lib64/python3.9` contains the modules in [the Python standard library](https://docs.python.org/3/library/).

### Importing your Python files

If you create a file with the `a.py` name:

```
def f():
    return 2
```

, and another with the `b.py` name:

```
import a

print(a.f())
```

, then:

```
$ python b.py
2
```


This works, because `sys.path` contains `''`, which means "the current directory".

(`sys.path` is very similar to the `PATH` variable. However, `sys.path` contains the current directory by default, whereas `PATH` does not.)

When `import a` is executed, then Python searches the directories in `sys.path` for an `a.py` file; it is found when checking the `''` path.
When `import datetime` is executed, Python searches in the current directory (because `''` comes first in the path), doesn't find it, but then finds it in the following `/usr/lib64/python3.9` directory.
Python iterates over the `sys.path` directories, and loads the *first* matching file.

## Installing libraries

When writing Python software, sometimes it is enough with the modules included in the standard library.
However, frequently you want to use other libraries.
To use Python libraries, you must install them using the `pip` command.

The `pip` command is not part of the `python3` package in some Linux distributions, and comes from the `python3-pip` package.

The `pip` command can download libraries from https://pypi.org/ , the Python package index, and install them.
`pip` installs libraries to a "Python environment".

Old versions of `pip` defaulted to installing libraries to the "system" Python environment.
In a Linux system, the system Python environment is located in a directory such as `/usr/lib64/python3.9`.
By default, normal Linux users cannot write to `/usr`, so installing a package would fail.

Modern versions of `pip` detect that they cannot write to the "system" Python environment, and then redirect the install to the "user" Python environment.
The "user" Python environment is in a directory such as `~/.local/lib/python3.9`.

You could use a command such as `sudo pip install` to grant `pip` the privileges required to write to `/usr`.
However, this can make a Linux system unusable.
Most Linux systems use software that uses the "system" Python environment.
Altering the "system" Python environment can break such software.
Do not run `sudo pip install` with root privileges unless you know why you need this.

If you use a modern `pip` (or use the `pip install --user` command), you can install libraries to the "user" Python environment.
However, this is problematic because a Python environment can only contain a single version of a Python library.
If you have two different Python programs that different versions of the same library, then these two programs cannot coexist in the "user" Python environment.

In general, Python virtual environments are used to address this problem.

## Creating Python virtual environments

If you run:

```
$ python3 -m venv <some path>
```

This will create a directory with the path you specify, with the following contents:

```
<some path>
├── bin
│   ├── activate
│   ├── pip
│   ├── python
├── include
├── lib
│   └── python3.9
```

The `python` and `pip` commands are copies of the same commands from the "system" Python environment.

But these commands work differently from the "system" Python environment commands:

```
$ <some path>/bin/python
>>> import sys
>>> sys.path
['', '/usr/lib64/python39.zip', '/usr/lib64/python3.9', '/usr/lib64/python3.9/lib-dynload', '<some path>/lib64/python3.9/site-packages', '<some path>/lib/python3.9/site-packages']
```

`sys.path` uses the `lib` directories in the virtual environment.

When you use the `pip` command from the virtual environment, it installs the libraries to the virtual environment.

You can create as many virtual environments as you need, and you can install different versions of libraries to each virtual environment.

## Activating Python environments

You can run the `python` and `pip` commands by specifying the full path, like we did when executing the `foo.sh` command earlier.

By default, if you run `python`, the shell will invoke the `python` command from the "system" Python environment because it is in a directory included in the `PATH` variable.
If you specify the full path, you override this.

To save typing, the `bin` directory of a virtual environment contains an `activate` file.
The `activate` file is a "special" shell script that must be invoked in one of the following two ways:

```
$ source <some path>/bin/activate
```

```
$ . <some path>/bin/activate
```

`source` and `.` are synonyms.
They are special shell commands that are needed for the `activate` command to work correctly.

`activate` alters your path, so that the `bin` directory in your virtual environment comes first in your path.

```
$ echo $PATH
/home/user/.local/bin:/home/user/bin:/usr/share/Modules/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin
$ . <some path>/bin/activate
(some path) $ echo $PATH
<some path>/bin:/home/user/.local/bin:/home/user/bin:/usr/share/Modules/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin
```

, and thus if you run `python`, `<some path>/bin/python` will be executed instead of `/usr/bin/python`.

Besides changing your prompt to indicate the virtual environment is activated, `activate` only alters your `PATH`.
You can never use `activate` if you always specify the path to the virtual environment commands.
