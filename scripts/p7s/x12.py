import os
import pathlib
import subprocess
import textwrap
import tempfile


def setup_x12():
    switcher = pathlib.Path(__file__).parent.parent.parent / "linux" / "thinkpad_x12_fn_switcher/"
    binary = pathlib.Path.home() / ".local" / "bin" / "x12_fn_switcher"
    subprocess.run(["gcc", switcher / "x12_fn_switcher.c", "-o", binary, "-I/usr/include/libusb-1.0", "-lusb-1.0"], check=True)
    os.chmod(binary, 0o700)
    with tempfile.TemporaryDirectory() as tempdir:
        tempdir = pathlib.Path(tempdir)
        pathlib.Path(tempdir/ "99-thinkpad-fn.rules").write_text(textwrap.dedent(f"""
        ACTION=="add", ATTRS{{idVendor}}=="17ef", ATTRS{{idProduct}}=="60fe", RUN+="{binary}"
        """).lstrip())
        subprocess.run(["sudo", "cp", tempdir/ "99-thinkpad-fn.rules", "/etc/udev/rules.d/99-thinkpad-fn.rules"], check=True)
    subprocess.run(["sudo", "udevadm", "control", "--reload-rules"], check=True)
    subprocess.run(["sudo", "udevadm", "trigger"], check=True)
