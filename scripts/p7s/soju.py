import pathlib
import textwrap


def setup_soju():
    home = pathlib.Path.home()
    config = home / ".config" / "containers" / "systemd"
    config.mkdir(parents=True, exist_ok=True)
    (config / "soju.container").write_text(textwrap.dedent("""
        [Unit]
        Description=IRC Bouncer

        [Container]
        Image=quay.io/alexpdp7/workstation:latest
        Volume=/home/alex/.config/containers/systemd/soju_config:/etc/soju/config
        Volume=/home/alex/.local/lib/soju:/var/lib/soju/
        # running this on an LXC container, which borks SecurityLabelDisable
        #SecurityLabelDisable=true
        Network=host

        Exec=soju

        [Service]
        # Extend Timeout to allow time to pull the image
        TimeoutStartSec=900

        [Install]
        # Start by default on boot
        WantedBy=multi-user.target default.target
    """).lstrip())

    (config / "soju_config").write_text(textwrap.dedent("""
        db sqlite3 /var/lib/soju/main.db
        message-store fs /var/lib/soju/logs/
        listen irc+insecure://0.0.0.0:6667
    """).lstrip())

    (home / ".local" / "lib" / "soju").mkdir(parents=True, exist_ok=True)

    sojudb_wrapper = (home / ".local" / "bin" / "sojudb")
    sojudb_wrapper.write_text(textwrap.dedent("""
        #!/bin/sh

        podman run -it --rm --security-opt label=disable -v ~/.config/containers/systemd/soju_config:/etc/soju/config -v ~/.local/lib/soju/:/var/lib/soju quay.io/alexpdp7/workstation:latest sojudb "$@"
    """).lstrip())
    sojudb_wrapper.chmod(0o755)
