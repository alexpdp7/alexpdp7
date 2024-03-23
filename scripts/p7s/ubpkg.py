import os
import pathlib
import shutil

import httpx


def setup_ubpkg():
    ubpkg = pathlib.Path.home() / ".local" / "bin" / "ubpkg"
    ubpkg.write_bytes(httpx.get("https://github.com/alexpdp7/ubpkg/releases/latest/download/ubpkg-linux", follow_redirects=True).content)
    os.chmod(ubpkg, 0o700)
