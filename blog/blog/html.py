import itertools
import textwrap

import htmlgenerator as h

from blog import meta, pretty, gemtext


def html_template(*content, page_title=None, full):
    title = [h.A(meta.TITLE, href=f"{meta.SCHEMA}://{meta.HOST}")]
    if page_title:
        title += f" - {page_title}"

    title = h.BaseElement(*title)

    links = list(itertools.chain(*[(h.A(text, href=href), ", ") for text, href in meta.LINKS]))

    links += h.BaseElement(f" {meta.EMAIL_TEXT}")

    full_part = []
    if full:
        full_part = [
            h.H2(meta.SUBTITLE),
            h.P(*links),
        ]

    return pretty.pretty_html(h.render(
        h.HTML(
            h.HEAD(
                h.TITLE(meta.TITLE + (f" - {page_title}" if page_title else "")),
                h.LINK(rel="alternate", type="application/rss+xml", title=meta.TITLE, href=f"{meta.SCHEMA}://{meta.HOST}/feed/"),
                h.STYLE(textwrap.dedent("""
                    body {
                        max-width: 40em;
                        margin-left: auto;
                        margin-right: auto;
                        padding-left: 2em;
                        padding-right: 2em;
                        background-color: #fffffa;
                    }
                    p, blockquote, li {
                        /* from Mozilla reader mode */
                        line-height: 1.6em;
                        font-size: 20px;
                    }
                """).lstrip())
            ),
            h.BODY(
                h.H1(title),
                *full_part,
                *content,
            ),
            doctype="html",
        ),
        {},
    ))


def gemini_to_html(parsed):
    i = 0
    result = []
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
                    url = url.replace("gemini://alex.corcoles.net/", f"{meta.SCHEMA}://{meta.HOST}/")
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
