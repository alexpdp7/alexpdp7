import subprocess

# Needs the https://github.com/ChrisRegado/streamdeck-googlemeet/releases/latest browser extension and websocat

def toggle_mute():
    subprocess.run([
        "websocat",
        "--text",
        "--oneshot",
        'literal:{"event":"toggleMic"}',
        "ws-listen:127.0.0.1:2394"
    ], check=True)
