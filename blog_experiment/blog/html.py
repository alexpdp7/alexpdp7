import bs4
import htmlgenerator as h

from blog import meta


def html_template(*content, page_title=None):
    title = "El blog es mío"
    if page_title:
        title += f" - {page_title}"
    return bs4.BeautifulSoup(h.render(
        h.HTML(
            h.HEAD(h.TITLE(title)),
            h.BODY(
                h.H1(meta.TITLE),
                h.H2(meta.SUBTITLE),
                *content,
            ),
            doctype="html",
        ),
        {},
    ), features="html.parser").prettify()
