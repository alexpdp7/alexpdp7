import yaml


with open("post.yml") as f:
    posts = yaml.load(f)

posts = [dict(post) for post in posts]

for post in posts:
    post["post"] = post["post"].encode("iso-8859-1").decode("utf8")
    post["title"] = post["title"].encode("iso-8859-1").decode("utf8")