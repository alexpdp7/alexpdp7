#!/usr/bin/env python3
import pathlib
import shutil
import subprocess
import textwrap


def _(t):
    return textwrap.dedent(t).lstrip()


print("Installing some packages...")
subprocess.run(["sudo", "dnf", "install", "-y", "rclone", "fuse", "git", "podman-docker", "wget"], check=True)

home = pathlib.Path.home()

if not (home / ".config" / "rclone" / "rclone.conf").exists():
    print(_("""
        Visit https://nextcloud.pdp7.net/nextcloud/index.php/settings/user/security , create an app password
    """))

    subprocess.run(["rclone", "config", "create", "nextcloud", "webdav", "url=https://nextcloud.pdp7.net/nextcloud/remote.php/dav/files/alex/", "vendor=nextcloud", "user=alex", "--all"], check=True)


(home / "Nextcloud").mkdir(exist_ok=True)


nextcloud_service_path = home / ".config" / "systemd" / "user" / "nextcloud.service"
nextcloud_service_path.parent.mkdir(parents=True, exist_ok=True)


with open(nextcloud_service_path, "w", encoding="utf8") as f:
    f.write(_("""
        [Unit]

        [Service]
        ExecStart=/usr/bin/rclone mount --vfs-cache-mode=full --dir-perms 700 --file-perms 600 nextcloud: /home/alex/Nextcloud/

        [Install]
        WantedBy=default.target
    """))

subprocess.run(["systemctl", "--user", "enable", "--now", "nextcloud"], check=True)

if not (home / ".ssh").exists():
    subprocess.run(["ln", "-s", "Nextcloud/_ssh", ".ssh"], check=True)


dotfiles_dir = home / "Nextcloud" / "dotfiles"

for dotfile in dotfiles_dir.glob("*"):
    relative_dotfile = dotfile.relative_to(dotfiles_dir)
    replaced_dotfile = pathlib.Path.home() / ("." + relative_dotfile.parts[0][1:])
    if not replaced_dotfile.exists():
        subprocess.run(["ln", "-s", dotfile, replaced_dotfile], check=True)


(home / ".local" / "bin").mkdir(exist_ok=True, parents=True)

(home / "git").mkdir(exist_ok=True, parents=True)

distrobox_dir = home / "git" / "distrobox"

if not distrobox_dir.exists():
    subprocess.run(["git", "clone", "https://github.com/89luca89/distrobox.git", distrobox_dir], check=True)

subprocess.run([distrobox_dir / "install"], check=True)
