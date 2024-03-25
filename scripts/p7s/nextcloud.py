import argparse
import pathlib
import subprocess
import textwrap


def setup_nextcloud():
    parser = argparse.ArgumentParser()
    parser.add_argument("style", choices=["noinstall", "flatpak", "rclone"])
    args = parser.parse_args()

    home = pathlib.Path.home().absolute()

    if args.style == "rclone":
        if not (home / ".config" / "rclone" / "rclone.conf").exists():
            print("Visit https://nextcloud.pdp7.net/nextcloud/index.php/settings/user/security , create an app password")

            subprocess.run(["rclone", "config", "create", "nextcloud", "webdav", "url=https://nextcloud.pdp7.net/nextcloud/remote.php/dav/files/alex/", "vendor=nextcloud", "user=alex", "--all"], check=True)

        (home / "Nextcloud").mkdir(exist_ok=True)

        nextcloud_service_path = home / ".config" / "systemd" / "user" / "nextcloud.service"
        nextcloud_service_path.parent.mkdir(parents=True, exist_ok=True)

        nextcloud_service_path.write_text(textwrap.dedent("""
            [Unit]

            [Service]
            ExecStart=/usr/bin/rclone mount --vfs-cache-mode=full --dir-perms 700 --file-perms 600 nextcloud: /home/alex/Nextcloud/

            [Install]
            WantedBy=default.target
        """).lstrip())

        subprocess.run(["systemctl", "--user", "enable", "--now", "nextcloud"], check=True)
    elif args.style == "flatpak":
        subprocess.run(["flatpak", "install", "com.nextcloud.desktopclient.nextcloud"], check=True)
        input("complete the setup")

    if not (home / ".ssh").exists():
        subprocess.run(["ln", "-s", home / "Nextcloud" / "_ssh", home / ".ssh"], check=True)

    dotfiles_dir = home / "Nextcloud" / "dotfiles"

    for dotfile in dotfiles_dir.glob("*"):
        relative_dotfile = dotfile.relative_to(dotfiles_dir)
        replaced_dotfile = pathlib.Path.home() / ("." + relative_dotfile.parts[0][1:])
        if not replaced_dotfile.exists():
            subprocess.run(["ln", "-s", dotfile, replaced_dotfile], check=True)
