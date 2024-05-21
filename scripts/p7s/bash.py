import pathlib
import platform
import textwrap


def is_ubuntu_2204():
    return platform.freedesktop_os_release().get("VERSION_CODENAME") == "jammy"


def setup_bash():
    if is_ubuntu_2204():
        # clone the handy ~/.bashrc.d from Fedora
        bash_aliases = pathlib.Path.home() / ".bash_aliases"
        bash_aliases.write_text(textwrap.dedent("""
            # User specific aliases and functions
            if [ -d ~/.bashrc.d ]; then
                for rc in ~/.bashrc.d/*; do
                    if [ -f "$rc" ]; then
                        . "$rc"
                    fi
                done
            fi
            unset rc
        """.lstrip()))
