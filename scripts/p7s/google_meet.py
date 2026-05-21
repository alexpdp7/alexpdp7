import subprocess

from p7s import multiline_string as _
from p7s import systemd

"""
Needs:

* https://github.com/ChrisRegado/streamdeck-googlemeet/releases/latest
* https://github.com/vi/wsbroad
* https://github.com/vi/websocat/
"""


def install_stream_deck_google_meet_wsbroad_server():
    systemd.create_user_unit("stream-deck-google-meet-wsbroad.service", _("""
    [Unit]
    Description=Server for streamdeck-googlemeet browser extension based on wsbroad

    [Service]
    ExecStart=/home/alex/.local/bin/wsbroad 127.0.0.1:2394

    [Install]
    WantedBy=default.target
    """))

    systemd.reload()
    systemd.enable_now("stream-deck-google-meet-wsbroad.service")


def toggle_mute():
    subprocess.run([
        "websocat",
        "--text",
        "--oneshot",
        'literal:{"event":"toggleMic"}',
        "ws://127.0.0.1:2394"
    ], check=True)
