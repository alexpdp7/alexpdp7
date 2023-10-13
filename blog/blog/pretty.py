from lxml import etree, html


def pretty_html(s):
    return etree.tostring(html.fromstring(s), pretty_print=True).decode("utf8")
