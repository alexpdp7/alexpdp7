#!/usr/bin/python3

import datetime
import pathlib
import shlex
import subprocess
import sys

def _(*args):
    print(shlex.join(args))
    subprocess.run(args, check=True)

def clean():
    _("rpm", "--rebuilddb")
    _("dnf", "clean", "all")

def update_enabled(repo):
    clean()
    _("dnf", "update", "-y", "--disablerepo=*", "--enablerepo", repo)

repolist = subprocess.run(["dnf", "repolist"], check=True, stdout=subprocess.PIPE, text=True).stdout
repos = [lps[0] for lps in map(str.split, repolist.splitlines()[1:])]

failed = []

for r in repos:
    try:
        update_enabled(r)
    except Exception as e:
        failed.append(r)
        print(f"fail {r}: {e}")

if not failed:
    sys.exit(0)

failed_path = pathlib.Path("failed")

existing_failed = failed_path.read_text() if failed_path.exists() else ""

for f in failed:
    existing_failed += f"{f} {datetime.date.today()}\n"

failed_path.write_text(existing_failed)

print(f"failed {failed}, wrote to {failed_path}")
