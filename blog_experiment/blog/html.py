import bs4
import htmlgenerator as h


def html_template(*content):
    return bs4.BeautifulSoup(h.render(
        h.HTML(
            h.HEAD(h.TITLE("El blog es mío")),
            h.BODY(
                h.H1("El blog es mío"),
                h.H2("Hay otros como él, pero este es el mío"),
                *content,
            ),
            doctype="html",
        ),
        {},
    ), features="html.parser").prettify()
