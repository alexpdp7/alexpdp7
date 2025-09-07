"""
We could likely make this nicer with some mail configuration autodiscovery, but who has the time.
"""
import textwrap


def mbsync_gmail(login, password, store_path):
    return textwrap.dedent(f"""
        IMAPAccount {login}
        Host imap.gmail.com
        SSLType IMAPS
        User {login}
        Pass {password}

        IMAPStore {login}-remote
        Account {login}

        MaildirStore {login}-local
        SubFolders Verbatim
        Path {store_path}/{login}/
        Inbox {store_path}/{login}/INBOX

        Channel {login}
        Far :{login}-remote:
        Near :{login}-local:
        Patterns *
        Create Both
        Expunge Both
        SyncState *
    """).lstrip()


def mbsync_yahoo(login, password, store_path):
    return textwrap.dedent(f"""
        IMAPAccount {login}
        Host imap.mail.yahoo.com
        SSLType IMAPS
        User {login}
        Pass {password}
        PipelineDepth 5

        IMAPStore {login}-remote
        Account {login}

        MaildirStore {login}-local
        SubFolders Verbatim
        Path {store_path}/{login}/
        Inbox {store_path}/{login}/Inbox

        Channel {login}
        Far :{login}-remote:
        Near :{login}-local:
        Patterns *
        Create Both
        Expunge Both
        SyncState *
    """).lstrip()
