import pathlib
import re

import bicephalus

import htmlgenerator as h

from blog import blog_pages, page, html, pretty, gemtext


class AboutPage(page.BasePage):
    def get_gemini_content(self):
        return (
            bicephalus.Status.OK,
            "text/gemini",
            pathlib.Path("static/about/index.gmi").read_text(),
        )

    def get_http_content(self):
        return (
            bicephalus.Status.OK,
            "text/html",
            pretty.pretty_html(h.render(
            h.HTML(
                h.HEAD(
                    h.TITLE("About Álex Córcoles"),
                ),
                h.BODY(*html.gemini_to_html(gemtext.parse(self.get_gemini_content()[2])))
            ), {})),
        )


def handler(request: bicephalus.Request) -> bicephalus.Response:
    if request.path == "/":
        return blog_pages.Root(request).response()
    if re.match(r"/\d{4}/\d{2}/.*/", request.path):
        blog_file = pathlib.Path("content") / (request.path[1:-1] + ".gmi")
        if blog_file.exists():
            return blog_pages.EntryPage(request, blog_file).response()
    if request.path == "/feed/" and request.proto == bicephalus.Proto.HTTP:
        return blog_pages.Root(request).feed()
    if request.path == "/about/":
        return AboutPage(request).response()

    return page.NotFound(request).response()
