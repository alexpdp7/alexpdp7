import pathlib
import subprocess


def setup_paperwm():
    install = (pathlib.Path(__file__).parent.parent / "PaperWM" / "install.sh")
    subprocess.run([install], check=True)
