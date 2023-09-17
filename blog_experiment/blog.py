import datetime
import itertools
import logging
import pathlib
import subprocess
import textwrap

import htmlgenerator as h

import bicephalus
from bicephalus import main as bicephalus_main
from bicephalus import otel
from bicephalus import ssl


def tidy(s):
    p = subprocess.run(
        ["tidy", "--indent", "yes", "-q", "-wrap", "160"],
        input=s,
        stdout=subprocess.PIPE,
        encoding="UTF8",
    )
    return p.stdout


class BasePage:
    def __init__(self, request):
        self.request = request

    def response(self):
        if self.request.proto == bicephalus.Proto.GEMINI:
            status, content_type, content = self.get_gemini_content()
        elif self.request.proto == bicephalus.Proto.HTTP:
            status, content_type, content = self.get_http_content()
        else:
            assert False, f"unknown protocol {self.request.proto}"

        return bicephalus.Response(
            content=content.encode("utf8"),
            content_type=content_type,
            status=bicephalus.Status.OK,
        )


class Entry:
    def __init__(self, path: pathlib.Path):
        assert path.is_relative_to(pathlib.Path("content")), f"bad path {path}"
        self.path = path
        self.content = path.read_text()

    @property
    def title(self):
        return self.content.splitlines()[0][2:]

    @property
    def posted(self):
        return datetime.date.fromisoformat(self.content.splitlines()[1])

    @property
    def uri(self):
        return f"/{self.path.parts[1]}/{self.path.parts[2]}/{self.path.stem}/"


class Root(BasePage):
    def entries(self):
        entries = map(Entry, pathlib.Path("content").glob("*/*/*.gmi"))
        return sorted(entries, key=lambda e: e.posted, reverse=True)

    def get_gemini_content(self):
        posts = "\n".join([f"=> {e.uri} {e.posted} {e.title}" for e in self.entries()])
        content = (
            textwrap.dedent(
                f"""\
                # El blog es mío

                ## Hay otros como él, pero este es el mío

                ____
                """
            )
            + posts
        )
        return bicephalus.Status.OK, "text/gemini", content

    def get_http_content(self):
        posts = [
            (h.H3(h.A(f"{e.title} ({e.posted})", href=e.uri))) for e in self.entries()
        ]
        return (
            bicephalus.Status.OK,
            "text/html",
            tidy(
                h.render(
                    h.HTML(
                        h.HEAD(h.TITLE("El blog es mío")),
                        h.BODY(
                            h.H1("El blog es mío"),
                            h.H2("Hay otros como él, pero este es el mío"),
                            *itertools.chain(posts),
                        ),
                    ),
                    {},
                )
            ),
        )


class NotFound(BasePage):
    def get_gemini_content(self):
        # TODO: does not work!
        return (
            bicephalus.Status.NOT_FOUND,
            "text/gemini",
            f"{self.request.path} not found",
        )

    def get_http_content(self):
        return (
            bicephalus.Status.NOT_FOUND,
            "text/html",
            f"{self.request.path} not found",
        )


def handler(request: bicephalus.Request) -> bicephalus.Response:
    if request.path == "/":
        return Root(request).response()
    return NotFound(request).response()


def main():
    otel.configure_logging(logging.INFO)
    with ssl.temporary_ssl_context("localhost") as ssl_context:
        bicephalus_main.main(handler, ssl_context, 8000)


if __name__ == "__main__":
    main()
