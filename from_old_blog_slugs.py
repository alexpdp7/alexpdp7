import pathlib
import re
import subprocess
import yaml


def slug(s):
    orig = s
    s = re.sub(r"""[*\^/\-":+#.,¿?¡!()[\]'%]+""", " ", s)
    s = s.strip()
    s = re.sub(" +", "-", s)
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
    assert re.match(r"^[a-z0-9\-]+$", s), (orig, s)
    return s


with open("post.yml") as f:
    posts = yaml.load(f)

posts = [dict(post) for post in posts]

replacements = {}

for post in posts:
    post["post"] = post["post"].encode("iso-8859-1").decode("utf8")
    post["title"] = post["title"].encode("iso-8859-1").decode("utf8")

    post["post"] = post["post"].replace("\\r\\n", " ")

    t = post["title"]

    y,m,d = post["posted"].split(" ")[0].split("-")

#    print(f"http://eucaliptus.ath.cx/~alex/blog/?query=byId&postId={post['id']}", f"gemini://alex.corcoles.net/{y}/{m}/{slug(post['title'])}/")
    replacements[f"http://eucaliptus.ath.cx/~alex/blog/?query=byId&postId={post['id']}"] = f"gemini://alex.corcoles.net/{y}/{m}/{slug(post['title'])}/"
    replacements[f"https://eucaliptus.ath.cx/~alex/blog/?query=byId&postId={post['id']}"] = f"gemini://alex.corcoles.net/{y}/{m}/{slug(post['title'])}/"
    replacements[f"?query=byId&postId={post['id']}"] = f"gemini://alex.corcoles.net/{y}/{m}/{slug(post['title'])}/"


for f in pathlib.Path("content/").glob("**/*.gmi"):
    with open(f) as fp:
        post = fp.read()
    for i, o in replacements.items():
        post = post.replace(i + " ", o + " ")
    with open(f, "w") as fp:
        fp.write(post)
