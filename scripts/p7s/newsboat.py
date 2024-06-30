import os
import sys


def main():
    env = os.environ.copy()
    env["LOCALE_ARCHIVE"] = "/usr/lib/locale/locale-archive"
    os.execve("/home/alex/.local/bin/nix-portable", ("nix-portable", "nix", "shell", "nixpkgs#newsboat", "-c", "newsboat"), env)
