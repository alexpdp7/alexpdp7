import datetime
import re
import sys
import urllib.request

import bs4
from feedgen import feed

url = sys.argv[1]
feed_size = int(sys.argv[2])
title = sys.argv[3]
id = sys.argv[4]


with urllib.request.urlopen(url) as f: 
    content = f.read().decode("utf8")


soup = bs4.BeautifulSoup(content, features="lxml")

posts = 0

f = feed.FeedGenerator()
f.title(title)
f.id(id)

for a in soup.find_all("a"):
    if posts == feed_size:
        break
    match = re.fullmatch("(....-..-..) (.*)", a.string)
    if not match:
        continue
    title = match.group(2)
    date = datetime.datetime.strptime(match.group(1), "%Y-%m-%d").date()
    
    fi = f.add_item()
    fi.title(title)
    fi.id(a["href"])
    fi.link(href=a["href"])
    fi.updated(datetime.datetime.combine(date, datetime.datetime.min.time(), tzinfo=datetime.timezone.utc))

    node = a.parent.next_sibling
    content = ""
    while True:
        node = node.next_sibling
        if node and node.name == "p" and node.a and node.a.string and re.fullmatch("(....-..-..) (.*)", node.a.string):
            break
        if node and node.name == "h1" and node.string and node.string == "Sobre mí":
            break
        content += node if isinstance(node, bs4.NavigableString) else node.prettify() 
    fi.content(content)

    posts += 1

print(f.atom_str(pretty=True).decode("utf8"))