import importlib.resources
import re

import bicephalus

import htmlgenerator as h

from blog import blog_pages, gemtext, html, page, pretty


STATIC = importlib.resources.files("static").iterdir().__next__().parent


class SimplePage(page.BasePage):
    def __init__(self, request, url, title):
        super().__init__(request)
        self.url = url
        self.title = title

    def get_gemini_content(self):
        file = STATIC / self.url[1:] / "index.gmi"
        return (
            bicephalus.Status.OK,
            "text/gemini",
            file.read_text(),
        )

    def get_http_content(self):
        return (
            bicephalus.Status.OK,
            "text/html",
            pretty.pretty_html(
                h.render(
                    h.HTML(
                        h.HEAD(
                            h.TITLE(self.title),
                        ),
                        h.BODY(
                            *html.gemini_to_html(
                                gemtext.parse(self.get_gemini_content()[2])
                            )
                        ),
                    ),
                    {},
                )
            ),
        )


def handler(request: bicephalus.Request) -> bicephalus.Response:
    if not request.path.endswith("/"):
        return bicephalus.Response(
            request.path + "/", None, bicephalus.Status.PERMANENT_REDIRECTION
        )
    if request.path == "/":
        return blog_pages.Root(request).response()
    if re.match(r"/\d{4}/\d{2}/.*/", request.path):
        blog_file = blog_pages.CONTENT / (request.path[1:-1] + ".gmi")
        if blog_file.exists():
            return blog_pages.EntryPage(request, blog_file).response()
    if request.path == "/feed/" and request.proto == bicephalus.Proto.HTTP:
        return blog_pages.Root(request).feed()
    if request.path == "/about/":
        return SimplePage(request, request.path, "About Álex Córcoles").response()
    if request.path == "/laspelis/":
        return SimplePage(request, request.path, "laspelis").response()
    if re.match(r"/laspelis/\d+/", request.path):
        return SimplePage(
            request, request.path.removesuffix("/") + "/", request.path
        ).response()

    return page.NotFound(request).response()
