import pathlib
import shutil
import textwrap
import urllib.request


COSMO_BUILD_URL = "https://github.com/alexpdp7/superconfigure/releases/download/cleanup/editor.zip"


def setup_emacs():
    cache = pathlib.Path.home() / ".cache"
    editor_zip = cache / "editor.zip"
    urllib.request.urlretrieve(COSMO_BUILD_URL, editor_zip)

    superconfigure_cache = cache / "superconfigure"
    shutil.unpack_archive(editor_zip, superconfigure_cache)

    for b in (superconfigure_cache / "bin").glob("*"):
        b.chmod(0o755)

    bin = pathlib.Path.home() / ".local" / "bin"
    emacs = bin / "emacs"
    emacs.write_text(textwrap.dedent(f"""
        #!/bin/sh

        {superconfigure_cache}/bin/emacsclient --create-frame -t "$@" || {{
            {superconfigure_cache}/bin/emacs --daemon --user=""
            {superconfigure_cache}/bin/emacsclient --create-frame -t "$@"
        }}
    """).lstrip())
    emacs.chmod(0o755)
