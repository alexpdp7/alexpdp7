import pathlib
import re
import yaml


def slug(s):
    orig = s
    s = re.sub(r"""[*\^/\-":+#.,¿?¡!()[\]'%]+""", " ", s)
    s = s.strip()
    s = re.sub(" +", "_", s)
    s = s.lower()
    acc = {
        "áà": "a",
        "éè": "e",
        "íì": "i",
        "óò": "o",
        "úùü": "u",
        "ñ": "n",
        "ç": "c",
    }
    for ds, r in acc.items():
        for d in ds:
            s = s.replace(d, r)
    assert re.match("^[a-z0-9_]+$", s), (orig, s)
    return s


with open("post.yml") as f:
    posts = yaml.load(f)

posts = [dict(post) for post in posts]

for post in posts:
    post["post"] = post["post"].encode("iso-8859-1").decode("utf8")
    post["title"] = post["title"].encode("iso-8859-1").decode("utf8")

    y,m,d = post["posted"].split(" ")[0].split("-")

    p = pathlib.Path("content") / y / m / d / slug(post["title"])
