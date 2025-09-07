import getpass
import pathlib
import subprocess


def create_user_unit(name, content):
    user_units = pathlib.Path.home() / ".config" / "systemd" / "user"
    user_units.mkdir(exist_ok=True, parents=True)
    (user_units / name).write_text(content)


def reload():
    subprocess.run(["systemctl", "--user", "daemon-reload"], check=True)


def enable_now(unit):
    subprocess.run(["systemctl", "--user", "enable", "--now", unit], check=True)


def enable_linger():
    subprocess.run(["sudo", "loginctl", "enable-linger", getpass.getuser()], check=True)
