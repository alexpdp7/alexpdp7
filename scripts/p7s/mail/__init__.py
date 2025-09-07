import pathlib

from p7s import assert_single
from p7s import multiline_string as _
from p7s import bitwarden
from p7s.mail import imapfilter
from p7s.mail import mbsync
from p7s import systemd


MOM = "5c4d9e3b-121d-45f5-bab6-03b42d291326"
GMAIL = "f9bba940-769d-430a-82f4-5da10990e8fd"


def setup_mbsync():
    gmail = bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", GMAIL)["login"]
    yahoo = bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", MOM)["login"]
    (pathlib.Path.home() / (".mbsyncrc")).write_text(
        mbsync.mbsync_gmail(gmail["username"], gmail["password"], "~/Mail") +
        "\n" +
        mbsync.mbsync_yahoo(yahoo["username"], yahoo["password"], "~/Mail")
    )

    for username in [gmail["username"], yahoo["username"]]:
        (pathlib.Path.home() / "Mail" / username).mkdir(exist_ok=True, parents=True)

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
        "mom_to_gmail",
        _bitwarden_item_to_imapfilterserver("mom", bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", MOM)),
        _bitwarden_item_to_imapfilterserver("gmail", bitwarden.get_item("https://vaultwarden.pdp7.net", "alex@corcoles.net", GMAIL)),
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

    [Install]
    WantedBy=default.target
    """))

    systemd.reload()
    systemd.enable_now(unit)
    systemd.enable_linger()
