import itertools

import htmlgenerator as h

from blog import meta, pretty


def html_template(*content, page_title=None):
    title = [h.A(meta.TITLE, href=f"{meta.SCHEMA}://{meta.HOST}")]
    if page_title:
        title += f" - {page_title}"

    title = h.BaseElement(*title)

    links = list(itertools.chain(*[(h.A(text, href=href), ", ") for text, href in meta.LINKS]))

    links += h.BaseElement(f" {meta.EMAIL_TEXT}")

    return pretty.pretty_html(h.render(
        h.HTML(
            h.HEAD(
                h.TITLE(meta.TITLE + (f" - {page_title}" if page_title else "")),
                h.LINK(rel="alternate", type="application/rss+xml", title=meta.TITLE, href=f"{meta.SCHEMA}://{meta.HOST}/feed/"),
            ),
            h.BODY(
                h.H1(title),
                h.H2(meta.SUBTITLE),
                h.P(*links),
                *content,
            ),
            doctype="html",
        ),
        {},
    ))

