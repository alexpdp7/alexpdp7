import contextlib
import json
import os
import subprocess


class Bitwarden():
    @contextlib.contextmanager
    def login(self, server, email):
        subprocess.run(["bw", "config", "server", server], check=True)
        status = self.status()["status"]
        if status == "unauthenticated":
            command = ["login", email]
        elif status == "locked":
            command = ["unlock"]
        else:
            assert False, f"unexpected status {status}"
        command = subprocess.run(["bw"] + command, check=True, stdout=subprocess.PIPE, encoding="UTF8")
        export_line = command.stdout.splitlines()[3]
        session = export_line.split('"')[1]
        os.environ["BW_SESSION"] = session
        try:
            yield
            subprocess.run(["bw", "logout"], check=True)
        finally:
            del os.environ["BW_SESSION"]

    def sync(self):
        subprocess.run(["bw", "sync"], check=True)

    def status(self):
        return json.loads(subprocess.run(["bw", "status"], check=True, stdout=subprocess.PIPE).stdout)

    def get_item(self, uuid):
        return json.loads(subprocess.run(["bw", "get", "item", uuid], check=True, stdout=subprocess.PIPE).stdout)


def get_item(server, email, uuid):
    b = Bitwarden()
    with b.login(server, email):
        b.sync()
        return b.get_item(uuid)
