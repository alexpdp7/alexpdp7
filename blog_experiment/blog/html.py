import subprocess

import htmlgenerator as h


def tidy(s):
    p = subprocess.run(
        ["tidy", "--indent", "yes", "-q", "-wrap", "160"],
        input=s,
        stdout=subprocess.PIPE,
        encoding="UTF8",
    )
    return p.stdout


def html_template(*content):
    return tidy(
        h.render(
            h.HTML(
                h.HEAD(h.TITLE("El blog es mío")),
                h.BODY(
                    h.H1("El blog es mío"),
                    h.H2("Hay otros como él, pero este es el mío"),
                    *content,
                ),
            ),
            {},
        )
    )
