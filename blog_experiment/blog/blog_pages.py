import datetime
import itertools
import pathlib
import textwrap

import bicephalus

import htmlgenerator as h

from blog import html, page


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


class Root(page.BasePage):
    def entries(self):
        entries = map(Entry, pathlib.Path("content").glob("*/*/*.gmi"))
        return sorted(entries, key=lambda e: e.posted, reverse=True)

    def get_gemini_content(self):
        posts = "\n".join([f"=> {e.uri} {e.posted} {e.title}" for e in self.entries()])
        content = (
            textwrap.dedent(
                """\
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
            html.html_template(*itertools.chain(posts)),
        )


class EntryPage(page.BasePage):
    def __init__(self, request, path):
        super().__init__(request)
        self.path = path
        self.entry = Entry(path)

    def get_gemini_content(self):
        return bicephalus.Status.OK, "text/gemini", self.entry.content

    def get_http_content(self):
        return (
            bicephalus.Status.OK,
            "text/html",
            html.html_template(
                h.PRE(self.entry.content),
            ),
        )
