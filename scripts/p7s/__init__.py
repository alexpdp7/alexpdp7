import os, pathlib, shutil, subprocess, sys


def nix_portable(command):
    def main():
        os.environ["NP_RUNTIME"] = "bwrap"
        sys.exit(subprocess.run([shutil.which("nix-portable"), "nix", "run", f"nixpkgs#{command}"] + sys.argv[1:]).returncode)
    return main


BASHRC_D = pathlib.Path.home() / ".bashrc.d"
