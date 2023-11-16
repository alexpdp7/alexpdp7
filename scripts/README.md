I'm experimenting with doing "user-level" configuration using Python scripts.

This directory contains a Python module with entrypoints that I use for many tasks.

The scripts can be installed on EL8/EL9 with pipx:

```
$ pipx install -e . --force --python /usr/bin/python3.9
```

See [workstation](../workstation) for further details.
