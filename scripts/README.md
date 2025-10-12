I'm experimenting with doing "user-level" configuration using Python scripts.

This directory contains a Python module with entrypoints that I use for many tasks.

Bootstrapping on a Fedora toolbox:

```
dnf install pipx emacs-nox xclip
```

Bootstrapping on Debian:

```
sudo apt install git pipx emacs-nox xclip
```

```
mkdir git
cd git
git clone https://github.com/alexpdp7/alexpdp7.git
cd alexpdp7
pipx install -e scripts/  # alternatively, use uv tool install -e .
...
git remote set-url origin git@github.com:alexpdp7/alexpdp7.git
```

See [workstation](../workstation) for further details.
