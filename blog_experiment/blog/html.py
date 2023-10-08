import bs4
import htmlgenerator as h

from blog import meta


def html_template(*content, page_title=None):
    title = meta.TITLE
    if page_title:
        title += f" - {page_title}"
    return bs4.BeautifulSoup(h.render(
        h.HTML(
            h.HEAD(
                h.TITLE(title),
                h.LINK(rel="alternate", type="application/rss+xml", title=meta.TITLE, href=f"{meta.BASE_URL}/feed/"),
            ),
            h.BODY(
                h.H1(title),
                h.H2(meta.SUBTITLE),
                *content,
            ),
            doctype="html",
        ),
        {},
    ), features="html.parser").prettify()
