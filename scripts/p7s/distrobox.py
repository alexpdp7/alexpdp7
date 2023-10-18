import os
import subprocess


def create():
    subprocess.run(["distrobox", "create", "-i", "quay.io/alexpdp7/workstation:latest"], check=True)


def enter():
    os.execvp("distrobox", ["distrobox", "enter", "workstation-latest"])
