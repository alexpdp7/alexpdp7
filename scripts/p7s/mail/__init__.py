import pathlib
import subprocess
import textwrap

from p7s import bitwarden
from p7s.mail import mbsync


def generate_config():
    gmail = bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", "f9bba940-769d-430a-82f4-5da10990e8fd")["login"]
    yahoo = bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", "5c4d9e3b-121d-45f5-bab6-03b42d291326")["login"]
    (pathlib.Path.home() / (".mbsyncrc")).write_text(
        mbsync.mbsync_gmail(gmail["username"], gmail["password"], "~/Mail") +
        "\n" +
        mbsync.mbsync_yahoo(yahoo["username"], yahoo["password"], "~/Mail")
    )

    for username in [gmail["username"], yahoo["username"]]:
        (pathlib.Path.home() / "Mail" / username).mkdir(exist_ok=True, parents=True)

    user_units = pathlib.Path.home() / ".config" / "systemd" / "user"
    user_units.mkdir(exist_ok=True, parents=True)
    (user_units / "mbsync.service").write_text(textwrap.dedent("""
        [Unit]
        Description=Mail synchronization

        [Service]
        Type=oneshot
        ExecStart=/usr/bin/touch /home/alex/Mail/.lock ; /usr/bin/mbsync -qa ; /usr/bin/rm -f /home/alex/Mail/.lock
        """).lstrip())

    (user_units / "mbsync.timer").write_text(textwrap.dedent("""
        [Unit]
        Description=Mail synchronization

        [Install]
        WantedBy=timers.target

        [Timer]
        OnBootSec=1m
        OnActiveSec=0s
        OnUnitInactiveSec=30s
        Unit=mbsync.service
        """).lstrip())

    subprocess.run(["systemctl", "--user", "daemon-reload"], check=True)
    subprocess.run(["systemctl", "--user", "enable", "--now", "mbsync.timer"], check=True)
    subprocess.run(["sudo", "loginctl", "enable-linger", "alex"], check=True)

