#!/usr/bin/python3

import itertools
import shlex
import subprocess

def _(*args):
    print(shlex.join(args))
    subprocess.run(args, check=True)

def clean():
    _("rpm", "--rebuilddb")
    _("dnf", "clean", "all")

def update_disabled(repos):
    args = ["dnf", "update", "-y"] + list(itertools.chain(*[("--disablerepo", r) for r in repos]))
    _(*args)

def update_enabled(repos):
    args = ["dnf", "update", "-y", "--disablerepo=*"] + list(itertools.chain(*[("--enablerepo", r) for r in repos]))
    _(*args)

clean()

problematic_repos = ["copr:copr.fedorainfracloud.org:mlampe:emacs-30", "okay", "extras"]

update_disabled(problematic_repos)

failed = []

for r in problematic_repos:
    try:
        update_enabled([r])
    except Exception as e:
        failed.append(r)
        print(f"fail {r}: {e}")

print(f"failed {failed}")
