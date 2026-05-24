import os
import pathlib
import platform
import urllib.request


def setup_ubpkg():
    ubpkg = pathlib.Path.home() / ".local" / "bin" / "ubpkg"
    with urllib.request.urlopen(f"https://github.com/alexpdp7/ubpkg/releases/latest/download/ubpkg-linux-{platform.machine()}") as urlopen:
        ubpkg.write_bytes(urlopen.read())
    os.chmod(ubpkg, 0o700)
