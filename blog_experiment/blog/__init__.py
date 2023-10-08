import pathlib
import re

import bicephalus

from blog import blog_pages, page


def handler(request: bicephalus.Request) -> bicephalus.Response:
    if request.path == "/":
        return blog_pages.Root(request).response()
    if re.match(r"/\d{4}/\d{2}/.*/", request.path):
        blog_file = pathlib.Path("content") / (request.path[1:-1] + ".gmi")
        if blog_file.exists():
            return blog_pages.EntryPage(request, blog_file).response()
    if request.path == "/feed/" and request.proto == bicephalus.Proto.HTTP:
        return blog_pages.Root(request).feed()
    return page.NotFound(request).response()
