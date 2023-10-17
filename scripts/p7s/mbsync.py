import pathlib
import textwrap

from p7s import bitwarden


def generate_config():
    gmail_password = bitwarden.get_item("https://bitwarden.pdp7.net", "alex@corcoles.net", "cad137b0-cfd5-4d5c-b167-98a9e792f4cc")["login"]["password"]
    (pathlib.Path.home() / (".mbsyncrc")).write_text(textwrap.dedent(f"""
        IMAPStore gmail-remote
        Host imap.gmail.com
        SSLType IMAPS
        AuthMechs LOGIN
        User koalillo@gmail.com
        Pass "{gmail_password}"

        MaildirStore gmail-local
        Path ~/Mail/koalillo@gmail.com/
        Inbox ~/Mail/koalillo@gmail.com/INBOX
        Subfolders Verbatim

        Channel gmail
        Far :gmail-remote:
        Near :gmail-local:
        Create Both
        Expunge Both
        Patterns *
        SyncState *
    """))
