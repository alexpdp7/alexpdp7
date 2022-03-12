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

for post in posts:
    post["post"] = post["post"].encode("iso-8859-1").decode("utf8")
    post["title"] = post["title"].encode("iso-8859-1").decode("utf8")

    post["post"] = post["post"].replace("\\r\\n", " ")

    t = post["title"]

    y,m,d = post["posted"].split(" ")[0].split("-")

    p: pathlib.Path = pathlib.Path("content") / y / m / (slug(post["title"]) + ".gmi")
    p.parent.mkdir(parents=True, exist_ok=True)

    with open(p, "w") as f:
        f.write(f"# {t}\n")
        f.write(f"{y}-{m}-{d}\n\n")
        gmi = subprocess.run(["/home/alex/go/bin/html2gmi", "-mn"], input=post["post"].encode("utf8"), stdout=subprocess.PIPE).stdout.decode("utf8")
        gmi = "\n".join(map(str.rstrip, gmi.splitlines()))
        f.write(gmi)
