#!/usr/bin/python3
import os, shutil, subprocess, sys

def main():
    os.environ["NP_RUNTIME"] = "bwrap"
    sys.exit(subprocess.run([shutil.which("nix-portable"), "nix", "run", "nixpkgs#senpai"]).returncode)
