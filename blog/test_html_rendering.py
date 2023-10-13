import pathlib

import pytest

from blog import blog_pages


@pytest.mark.parametrize("entry", list(pathlib.Path("content").glob("*/*/*.gmi")))
def test_html_rendering(entry):
    blog_pages.Entry(entry).html()
