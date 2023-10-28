import pathlib
import textwrap


def setup_bitlbee():
    home = pathlib.Path.home()
    config = home / ".config" / "containers" / "systemd"
    config.mkdir(parents=True, exist_ok=True)
    (config / "bitlbee.container").write_text(textwrap.dedent("""
        [Unit]
        Description=IM-IRC bridge

        [Container]
        Image=quay.io/alexpdp7/workstation:latest
        Volume=/home/alex/.local/lib/bitlbee:/var/lib/bitlbee/
        # running this on an LXC container, which borks SecurityLabelDisable
        #SecurityLabelDisable=true
        PublishPort=6668:6667

        Exec=bitlbee -Fnv

        [Service]
        # Extend Timeout to allow time to pull the image
        TimeoutStartSec=900

        [Install]
        # Start by default on boot
        WantedBy=multi-user.target default.target
    """).lstrip())

    (home / ".local" / "lib" / "bitlbee").mkdir(parents=True, exist_ok=True)
