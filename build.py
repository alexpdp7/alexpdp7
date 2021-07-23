#!/usr/bin/env python3
import datetime
import os
import shutil
import textwrap


class Post:
    def __init__(self, slug, content):
        self.content = content
        self.slug = slug

    @property
    def title(self):
        return self.content.splitlines()[0][2:]

    @property
    def posted(self):
        return datetime.datetime.strptime(self.content.splitlines()[1], "%Y-%m-%d").date()

    @property
    def uri(self):
        yyyy = self.posted.strftime("%Y")
        mm = self.posted.strftime("%m")
        return f"{yyyy}/{mm}/{self.slug}"


    def __repr__(self):
        return f"Post(slug={self.slug},title={self.title},posted={self.posted}"


def load_posts():
    posts = []

    for directory, _, files in os.walk("content"):
        for file in files:
            if file.endswith("gmi"):
                with open(f"{directory}/{file}") as old_file:
                    posts.append(Post(file[:-4], old_file.read()))
            else:
                # FIXME
                pass

    return posts


def create_index(posts):
    with open("build/gmi/index.gmi", "w") as index:
        index.write(textwrap.dedent("""
            # El blog es mío

            ## Hay otros como él, pero este es el mío
        """).lstrip())

        index.write("_" * 80)
        index.write("\n")

        for post in posts[0:10]:
            index.write(textwrap.dedent(f"""
                => {post.uri} {post.posted} {post.title}

                ### {post.title}
            """))

            post_lines = post.content.splitlines()

            index.write("\n".join(post_lines[2:]))
            index.write("\n\n")
            index.write("_" * 80)
            index.write("\n")

        index.write(textwrap.dedent("""
            # Sobre mí

            => https://github.com/alexpdp7/ GitHub
            => https://es.linkedin.com/in/alexcorcoles LinkedIn
            => https://projecteuler.net/profile/koalillo.png Project Euler
            => https://stackexchange.com/users/13361/alex Stack Exchange
            => https://twitter.com/koalillo Twitter

            # El resto...
        """))



        for post in posts[10:]:
            index.write(textwrap.dedent(f"""
                => {post.uri} {post.posted} {post.title}
            """)[:-1])

def create_individual_posts(posts):
    for post in posts:
        os.makedirs(f"build/gmi/{post.uri}", exist_ok=True)
        with open(f"build/gmi/{post.uri}/index.gmi", "w") as post_file:
            post_file.write(textwrap.dedent("""
                => / El blog es mío

            """))
            post_file.write(post.content)
            post_file.write(textwrap.dedent(f"""

                => https://github.com/alexpdp7/gemini_blog/edit/master/content/{post.uri}.gmi Editar este post

                # Volver al inicio

                => / El blog es mío
            """))


def build():
    shutil.rmtree("build", ignore_errors=True)
    os.makedirs("build/gmi")

    posts = load_posts()
    create_index(sorted(posts, key=lambda p: p.posted, reverse=True))
    create_individual_posts(posts)
    for directory, _, files in os.walk("static/gmi"):
        new_dir = directory.replace("static/gmi", "build/gmi")
        for file in files:
            shutil.copy(f"{directory}/{file}", f"{new_dir}/{file}")

if __name__ == "__main__":
    build()
