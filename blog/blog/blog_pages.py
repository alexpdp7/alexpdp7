import datetime
import itertools
import pathlib
import textwrap

import bicephalus

import htmlgenerator as h

from feedgen import feed

from blog import html, page, gemtext, meta, pretty


def gemini_links():
    return "\n".join([f"=> {url} {text}" for text, url in meta.LINKS])


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

    @property
    def edit_url(self):
        return f"https://github.com/alexpdp7/alexpdp7/edit/master/blog/content{self.uri[:-1]}.gmi"

    def html(self):
        parsed = gemtext.parse(self.content)

        assert isinstance(parsed[0], gemtext.Header)
        assert parsed[0].level == 1
        assert isinstance(parsed[1], gemtext.Line)
        assert parsed[2] == gemtext.Line("")

        result = html.gemini_to_html(parsed[3:])
        result += [
            h.P(meta.EMAIL_TEXT),
            h.P(h.A("Editar", href=self.edit_url)),
        ]
        return result


class Root(page.BasePage):
    def entries(self):
        entries = map(Entry, pathlib.Path("content").glob("*/*/*.gmi"))
        return sorted(entries, key=lambda e: e.posted, reverse=True)

    def get_gemini_content(self):
        posts = "\n".join([f"=> {e.uri} {e.posted} {e.title}" for e in self.entries()])
        content = (
            textwrap.dedent(
                f"""\
                # {meta.TITLE}

                ## {meta.SUBTITLE}

                """
            )
            + gemini_links()
            + f"\n{meta.EMAIL_TEXT}\n"
            + "\n"
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
            html.html_template(*itertools.chain(posts), path=self.request.path, full=True),
        )

    def feed(self):
        fg = feed.FeedGenerator()
        fg.title(meta.TITLE)
        fg.subtitle(meta.SUBTITLE)
        fg.link(href=f"{meta.SCHEMA}://{meta.HOST}", rel="self")

        for entry in self.entries()[0:10]:
            fe = fg.add_entry()
            url = f"{meta.SCHEMA}://{meta.HOST}/{entry.uri}"
            fe.link(href=url)
            fe.published(datetime.datetime.combine(entry.posted, datetime.datetime.min.time(), tzinfo=datetime.timezone.utc))
            fe.title(entry.title)
            html = h.render(h.BaseElement(*entry.html()), {})
            html = pretty.pretty_html(html)
            fe.content(html, type="html")

        return bicephalus.Response(
            status=bicephalus.Status.OK,
            content_type="application/rss+xml",
            content=fg.rss_str(pretty=True),
        )


class EntryPage(page.BasePage):
    def __init__(self, request, path):
        super().__init__(request)
        self.path = path
        self.entry = Entry(path)

    def get_gemini_content(self):
        content = (
            textwrap.dedent(f"""\
                => gemini://{meta.HOST} alex.corcoles.net
                {meta.EMAIL_TEXT}

            """) +
            self.entry.content +
            textwrap.dedent(f"""\
                => {self.entry.edit_url} Editar
            """)
        )

        return bicephalus.Status.OK, "text/gemini", content

    def get_http_content(self):
        return (
            bicephalus.Status.OK,
            "text/html",
            html.html_template(
                *self.entry.html(),
                page_title=f"{self.entry.title} - {self.entry.posted}",
                path=self.request.path,
                full=False,
            ),
        )
