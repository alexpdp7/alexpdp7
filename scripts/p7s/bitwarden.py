import contextlib
import io
import json
import os
import subprocess
import zipfile

import httpx

from p7s import appdirs


class Bitwarden():
    def download(self, check_version=False):
        self.bw_command = appdirs.user_cache_dir() / "bw"
        if self.bw_command.exists() and not check_version:
            return self.bw_command
        r = httpx.get("https://vault.bitwarden.com/download/?app=cli&platform=linux")
        location = r.headers["location"]
        version = location.split("/")[7]
        bw_versioned_command = appdirs.user_cache_dir() / f"bw-{version}"
        if not bw_versioned_command.exists():
            with zipfile.ZipFile(io.BytesIO(httpx.get(location, follow_redirects=True).content)) as zip:
                with zip.open("bw") as zip_bw:
                    bw_versioned_command.write_bytes(zip_bw.read())
            bw_versioned_command.chmod(0o755)
        self.bw_command.unlink(missing_ok=True)
        self.bw_command.symlink_to(bw_versioned_command)

    @contextlib.contextmanager
    def login(self, server, email):
        subprocess.run([self.bw_command, "config", "server", server], check=True)
        status = self.status()["status"]
        if status == "unauthenticated":
            command = ["login", email]
        elif status == "locked":
            command = ["unlock"]
        else:
            assert False, f"unexpected status {status}"
        command = subprocess.run([self.bw_command] + command, check=True, stdout=subprocess.PIPE, encoding="UTF8")
        export_line = command.stdout.splitlines()[3]
        session = export_line.split('"')[1]
        os.environ["BW_SESSION"] = session
        try:
            yield self.bw_command
            subprocess.run([self.bw_command, "lock"], check=True)
        finally:
            del os.environ["BW_SESSION"]

    def status(self):
        return json.loads(subprocess.run([self.bw_command, "status"], check=True, stdout=subprocess.PIPE).stdout)

    def get_item(self, uuid):
        return json.loads(subprocess.run([self.bw_command, "get", "item", uuid], check=True, stdout=subprocess.PIPE).stdout)


def get_item(server, email, uuid):
    b = Bitwarden()
    b.download()
    with b.login(server, email):
        return b.get_item(uuid)
