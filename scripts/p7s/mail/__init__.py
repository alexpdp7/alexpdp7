import pathlib

from p7s import assert_single
from p7s import multiline_string as _
from p7s import bitwarden
from p7s.mail import imapfilter
from p7s.mail import mbsync
from p7s import systemd


MOM       = "5c4d9e3b-121d-45f5-bab6-03b42d291326"
GMAIL     = "f9bba940-769d-430a-82f4-5da10990e8fd"
MIGADU    = "e6157d00-5ab4-45da-947a-99667a52b828"
DREAMHOST = "196b080f-1cda-4c43-8df8-d5b9ed5bb07b"

def setup_mbsync():
    migadu = bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", MIGADU)["login"]

    (pathlib.Path.home() / (".mbsyncrc")).write_text(
        "\n".join([
            mbsync.mbsync_migadu(migadu["username"], migadu["password"], "~/Mail"),
        ])
    )

    (pathlib.Path.home() / "Mail" / migadu["username"]).mkdir(exist_ok=True, parents=True)

    systemd.create_user_unit("mbsync.service", _("""
    [Unit]
    Description=Mail synchronization

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/touch /home/alex/Mail/.lock ; /usr/bin/mbsync -qa ; /usr/bin/rm -f /home/alex/Mail/.lock
    """))

    systemd.create_user_unit("mbsync.timer", _("""
    [Unit]
    Description=Mail synchronization

    [Install]
    WantedBy=timers.target

    [Timer]
    OnBootSec=1m
    OnActiveSec=0s
    OnUnitInactiveSec=30s
    Unit=mbsync.service
    """))

    systemd.reload()
    systemd.enable_now("mbsync.timer")
    systemd.enable_linger()


def setup_imapfilter():
    create_forward(
        "mom_to_migadu",
        _bitwarden_item_to_imapfilterserver("mom", bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", MOM)),
        _bitwarden_item_to_imapfilterserver("migadu", bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", MIGADU)),
    )
    create_forward(
        "dreamhost_to_migadu",
        _bitwarden_item_to_imapfilterserver("dreamhost", bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", DREAMHOST)),
        _bitwarden_item_to_imapfilterserver("migadu", bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", MIGADU)),
    )
    create_forward(
        "gmail_to_migadu",
        _bitwarden_item_to_imapfilterserver("gmail", bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", GMAIL)),
        _bitwarden_item_to_imapfilterserver("migadu", bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", MIGADU)),
    )


def _bitwarden_item_to_imapfilterserver(name, i):
    return imapfilter.ImapServer(
        name=name,
        server=assert_single([f for f in i["fields"] if f["name"] == "imap_server"])["value"],
        username=i["login"]["username"],
        password=i["login"]["password"],
    )


def create_forward(name, from_server, to_server):
    config = pathlib.Path.home() / ".imapfilter" / f"{name}.lua"
    config.write_text(
        imapfilter.Sync(from_server=from_server, to_server=to_server).lua()
    )

    unit = f"imapfilter-{name}.service"
    systemd.create_user_unit(unit, _(f"""
    [Service]
    ExecStart=/usr/bin/imapfilter -c {config} -v
    Restart=always
    RestartSec=60

    [Install]
    WantedBy=default.target
    """))

    systemd.reload()
    systemd.enable_now(unit)
    systemd.enable_linger()
