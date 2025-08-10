import pathlib
import platform
import textwrap


def is_ubuntu_2204():
    return platform.freedesktop_os_release().get("VERSION_CODENAME") == "jammy"


def is_ubuntu_2404():
    return platform.freedesktop_os_release().get("VERSION_CODENAME") == "noble"


def is_debian_bookworm():
    return platform.freedesktop_os_release().get("VERSION_CODENAME") == "bookworm"


def is_debian_trixie():
    return platform.freedesktop_os_release().get("VERSION_CODENAME") == "trixie"


def is_debian_based():
    return is_ubuntu_2204() or is_ubuntu_2404() or is_debian_bookworm() or is_debian_trixie()


def setup_bash():
    if is_debian_based():
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
