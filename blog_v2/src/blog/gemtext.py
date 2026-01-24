import dataclasses
import re
import textwrap

import htmlgenerator as h

from blog import gemtext
from blog import pretty


def parse(s):
    r"""
    >>> parse('''# Header 1
    ...
    ... ## Header 2
    ...
    ... ### Header 3
    ...
    ... * List 1
    ... * List 2
    ...
    ... > First line quote.
    ... > Second line of quote.
    ...
    ... ```
    ... Fenced
    ... Lines
    ... ```
    ...
    ... Paragraph.
    ...
    ... Another paragraph.
    ... ''')
    [Header(level=1, text='Header 1'),
     Line(text=''),
     Header(level=2, text='Header 2'),
     Line(text=''),
     Header(level=3, text='Header 3'),
     Line(text=''),
     List(items=[ListItem(text='List 1'),
                 ListItem(text='List 2')]),
     Line(text=''),
     BlockQuote(lines=[BlockQuoteLine(text='First line quote.'),
                       BlockQuoteLine(text='Second line of quote.')]),
     Line(text=''),
     Pre(content='Fenced\nLines\n'),
     Line(text=''),
     Line(text='Paragraph.'),
     Line(text=''),
     Line(text='Another paragraph.')]
    """
    lines = s.splitlines()

    i = 0
    gem = []

    while i < len(lines):
        line = parse_line(lines[i])

        if isinstance(line, Link):
            gem.append(line)
            i = i + 1
            continue

        if isinstance(line, Header):
            gem.append(line)
            i = i + 1
            continue

        if isinstance(line, ListItem):
            items = []
            while i < len(lines) and isinstance(parse_line(lines[i]), ListItem):
                items.append(parse_line(lines[i]))
                i = i + 1
            gem.append(List(items))
            continue

        if isinstance(line, BlockQuoteLine):
            quotes = []
            while i < len(lines) and isinstance(parse_line(lines[i]), BlockQuoteLine):
                quotes.append(parse_line(lines[i]))
                i = i + 1
            gem.append(BlockQuote(quotes))
            continue

        if isinstance(line, PreFence):
            content = ""
            i = i + 1
            while i < len(lines) and not isinstance(parse_line(lines[i]), PreFence):
                content += lines[i]
                content += "\n"
                i = i + 1
            gem.append(Pre(content))
            i = i + 1
            continue

        gem.append(line)
        i = i + 1

    return gem


def parse_line(l):
    if Link.is_link(l):
        return Link(l)
    if Header.is_header(l):
        return Header(l)
    if ListItem.is_list_item(l):
        return ListItem(l)
    if BlockQuoteLine.is_block_quote_line(l):
        return BlockQuoteLine(l)
    if PreFence.is_pre_fence(l):
        return PreFence()
    return Line(l)


@dataclasses.dataclass
class Link:
    """
    >>> Link("=> http://example.com")
    Link(url='http://example.com', text=None)

    >>> Link("=> http://example.com Example text")
    Link(url='http://example.com', text='Example text')
    """

    url: str
    text: str | None

    def __init__(self, line: str):
        assert Link.is_link(line)
        parts = line.split(None, 2)
        self.url = parts[1]
        self.text = parts[2] if len(parts) > 2 else None  # noqa: PLR2004, > 2 "magic constant"

    @staticmethod
    def is_link(line: str):
        return line.startswith("=>")


@dataclasses.dataclass
class Header:
    """
    >>> Header("# Level one")
    Header(level=1, text='Level one')

    >>> Header("## Level two")
    Header(level=2, text='Level two')

    >>> Header("### Level three")
    Header(level=3, text='Level three')
    """

    level: int
    text: str

    def __init__(self, line: str):
        assert Header.is_header(line)
        hashes, self.text = line.split(None, 1)
        self.level = len(hashes)

    @staticmethod
    def is_header(line: str):
        return re.match("#{1,3} .*", line)


@dataclasses.dataclass
class ListItem:
    """
    >>> ListItem("* foo")
    ListItem(text='foo')
    """

    text: str

    def __init__(self, line: str):
        assert ListItem.is_list_item(line)
        self.text = line[2:]

    @staticmethod
    def is_list_item(line: str):
        return line.startswith("* ")


@dataclasses.dataclass
class BlockQuoteLine:
    """
    >>> BlockQuoteLine("> foo")
    BlockQuoteLine(text='foo')

    >>> BlockQuoteLine(">foo")
    BlockQuoteLine(text='foo')
    """

    text: str

    def __init__(self, line: str):
        assert BlockQuoteLine.is_block_quote_line(line)
        self.text = line[2:] if line.startswith("> ") else line[1:]

    @staticmethod
    def is_block_quote_line(line: str):
        return line.startswith(">")


class PreFence:
    @staticmethod
    def is_pre_fence(line: str):
        return line == "```"


@dataclasses.dataclass
class Line:
    text: str


@dataclasses.dataclass
class List:
    items: list[ListItem]


@dataclasses.dataclass
class BlockQuote:
    lines: list[BlockQuoteLine]


@dataclasses.dataclass
class Pre:
    content: str


def convert(gemtext, title=None):
    content = parse(gemtext)
    if not title:
        title = content[0]
        assert isinstance(title, Header), title
        assert title.level == 1
        title = title.text

    return pretty.pretty_html(
        h.render(
            h.HTML(
                h.HEAD(
                    h.TITLE(title),
                    h.STYLE(
                        textwrap.dedent("""
                        :root {
                            color-scheme: light dark;
                        }
                        body {
                            max-width: 40em;
                            margin-left: auto;
                            margin-right: auto;
                            padding-left: 2em;
                            padding-right: 2em;
                        }
                        p, blockquote, li {
                            /* from Mozilla reader mode */
                            line-height: 1.6em;
                            font-size: 20px;
                        }
                        """).lstrip()
                    ),
                ),
                h.BODY(
                    *gemini_to_html(content),
                ),
                doctype="html",
            ),
            {},
        )
    )


def gemini_to_html(parsed):  # noqa: C901, PLR0912, PLR0915
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
