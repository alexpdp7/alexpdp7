import os
import subprocess


IMAGE="quay.io/alexpdp7/workstation:latest"
NAME="workstation-latest"


def create():
    subprocess.run(["distrobox", "create", "-i", IMAGE], check=True)


def enter():
    os.execvp("distrobox", ["distrobox", "enter", NAME])


def update():
    subprocess.run(["distrobox", "rm", "-f", NAME], check=True)
    subprocess.run(["podman", "rmi", IMAGE], check=True)
    subprocess.run(["podman", "pull", IMAGE], check=True)
    subprocess.run(["distrobox", "create", "-i", IMAGE], check=True)
