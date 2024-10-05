import pathlib
import subprocess
import textwrap

import p7s

def setup_emacs():
    p7s.BASHRC_D.mkdir(parents=True, exist_ok=True)
    (p7s.BASHRC_D / "emacs.bash").unlink(missing_ok=True)
    subprocess.run(["ln", "-s", (pathlib.Path(__file__).parent.parent.parent / "emacs" / "emacs.bash").absolute(), p7s.BASHRC_D / "emacs.bash"], check=True)
    (pathlib.Path.home() / ".emacs").unlink(missing_ok=True)
    subprocess.run(["ln", "-s", (pathlib.Path(__file__).parent.parent.parent / "emacs" / "emacs.el").absolute(), pathlib.Path.home() / ".emacs"], check=True)
