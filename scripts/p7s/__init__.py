import os, pathlib, shutil, subprocess, sys, textwrap


def nix_portable(command):
    def main():
        os.environ["NP_RUNTIME"] = "bwrap"
        sys.exit(subprocess.run([shutil.which("nix-portable"), "nix", "run", f"nixpkgs#{command}", "--"] + sys.argv[1:]).returncode)
    return main


BASHRC_D = pathlib.Path.home() / ".bashrc.d"


def multiline_string(s):
    return textwrap.dedent(s).lstrip()


def assert_single(l):
    assert len(l) == 1
    return l[0]

