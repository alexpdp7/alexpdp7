#!/usr/bin/env python3

DESCRIPTION = """
This script runs a command with a different network configuration using firejail.

THIS MIGHT BE UNSAFE. USE AT YOUR OWN CAUTION:

* Input might not be correctly validated.
* Use of firejail might not be correct.
"""

import argparse
import pathlib
import shlex
import subprocess
import tempfile
import textwrap


def main():
    parser = argparse.ArgumentParser(description=DESCRIPTION)

    parser.add_argument("network_interface")
    parser.add_argument("dns")
    parser.add_argument("gateway")
    parser.add_argument("ip")
    parser.add_argument("command", nargs="+")

    parser.add_argument("--route", nargs="*", help="destination,gateway")

    args = parser.parse_args()

    routes = "".join([_make_route(r) for r in args.route])

    command = shlex.join(args.command)

    with tempfile.TemporaryDirectory() as tempdir:
        script = pathlib.Path(tempdir) / "script"

        script.write_text(textwrap.dedent(
            f"""
            #!/bin/sh

            {routes}
            {command}
            """
        ).lstrip())
        script.chmod(0o555)
        command = ["sudo", "firejail", f"--net={args.network_interface}", f"--dns={args.dns}", f"--defaultgw={args.gateway}", f"--ip={args.ip}", f"--whitelist={script}", "--", script]

        subprocess.run(command, check=True)


def _make_route(argument):
    destination, gateway = argument.split(",")
    return shlex.join(["ip", "route", "add", destination, "via", gateway, "dev", "eth0"])

if __name__ == "__main__":
    main()
