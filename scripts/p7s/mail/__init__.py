import pathlib

from p7s import bitwarden
from p7s.mail import mbsync


def generate_config():
    gmail = bitwarden.get_item("https://bitwarden.pdp7.net", "alex@corcoles.net", "cad137b0-cfd5-4d5c-b167-98a9e792f4cc")["login"]
    yahoo = bitwarden.get_item("https://bitwarden.pdp7.net", "alex@corcoles.net", "e24727e7-c0ef-4c97-afd0-8497d547304c")["login"]
    (pathlib.Path.home() / (".mbsyncrc")).write_text(
        mbsync.mbsync_gmail(gmail["username"], gmail["password"], "~/Mail") +
        "\n" +
        mbsync.mbsync_yahoo(yahoo["username"], yahoo["password"], "~/Mail")
    )
