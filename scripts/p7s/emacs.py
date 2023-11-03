import pathlib
import textwrap


def setup_emacs():
    bin = pathlib.Path.home() / ".local" / "bin"
    emacs = bin / "emacs"
    emacs.write_text(textwrap.dedent("""
    #!/bin/sh

    ~/.cache/cosmo/bin/emacsclient --create-frame -t "$@" || {
        ~/.cache/cosmo/bin/emacs --daemon --user=""
        ~/.cache/cosmo/bin/emacsclient --create-frame -t "$@"
    }
    """))
    emacs.chmod(0o755)
