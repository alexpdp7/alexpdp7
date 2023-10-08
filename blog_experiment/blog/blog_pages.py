import datetime
import itertools
import pathlib
import textwrap

import bs4

import bicephalus

import htmlgenerator as h

from feedgen import feed

from blog import html, page, gemtext, meta


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

    def html(self):
        parsed = gemtext.parse(self.content)

        assert isinstance(parsed[0], gemtext.Header)
        assert parsed[0].level == 1
        assert isinstance(parsed[1], gemtext.Line)
        assert parsed[2] == gemtext.Line("")

        result = [h.H3(f"{parsed[0].text} - {parsed[1].text}")]

        parsed = parsed[3:]
        i = 0
        while i < len(parsed):
            gem_element = parsed[i]

            if isinstance(gem_element, gemtext.Header):
                header = [h.H1, h.H2, h.H3, h.H4, h.H5, h.H6][gem_element.level - 1]
                result.append(header(gem_element.text))
                i = i + 1
                continue

            if isinstance(gem_element, gemtext.List):
                result.append(h.UL(*[h.LI(i.text) for i in gem_element.items]))
                i = i + 1
                continue

            if isinstance(gem_element, gemtext.Link):
                url = gem_element.url
                if url.startswith("gemini://"):
                    if url.startswith("gemini://alex.corcoles.net/"):
                        url = url.replace("gemini://alex.corcoles.net/", meta.BASE_URL + "/")
                    else:
                        url = url.replace("gemini://", "https://portal.mozz.us/gemini/")

                result.append(h.P(h.A(gem_element.text or gem_element.url, href=url)))
                i = i + 1
                continue

            if gem_element == gemtext.Line(""):
                i = i + 1
                continue

            if isinstance(gem_element, gemtext.BlockQuote):
                content = []
                for line in gem_element.lines:
                    if line.text:
                        content.append(line.text)
                    content.append(h.BR())
                result.append(h.BLOCKQUOTE(*content))
                i = i + 1
                continue

            if isinstance(gem_element, gemtext.Line):
                paragraph = [gem_element.text]
                i = i + 1
                while i < len(parsed):
                    gem_element = parsed[i]
                    if isinstance(gem_element, gemtext.Line) and gem_element.text != "":
                        paragraph.append(h.BR())
                        paragraph.append(gem_element.text)
                        i = i + 1
                    else:
                        break
                result.append(h.P(*paragraph))
                continue

            if isinstance(gem_element, gemtext.Pre):
                result.append(h.PRE(gem_element.content))
                i = i + 1
                continue

            assert False, f"unknown element {gem_element}"

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

    def feed(self):
        fg = feed.FeedGenerator()
        fg.title(meta.TITLE)
        fg.subtitle(meta.SUBTITLE)
        fg.link(href=meta.BASE_URL, rel="self")

        for entry in self.entries()[0:10]:
            fe = fg.add_entry()
            url = f"{meta.BASE_URL}{entry.uri}"
            fe.link(href=url)
            fe.published(datetime.datetime.combine(entry.posted, datetime.datetime.min.time(), tzinfo=datetime.timezone.utc))
            fe.title(entry.title)
            html = h.render(h.BaseElement(*entry.html()), {})
            html = bs4.BeautifulSoup(html, features="html.parser").prettify()
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
        return bicephalus.Status.OK, "text/gemini", self.entry.content

    def get_http_content(self):
        return (
            bicephalus.Status.OK,
            "text/html",
            html.html_template(
                *self.entry.html(),
                page_title=f"{self.entry.title} - {self.entry.posted}",
            ),
        )
