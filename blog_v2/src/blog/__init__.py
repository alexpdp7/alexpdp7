import argparse
import datetime
import pathlib
import re
import shutil
import textwrap

from feedgen import feed
import lxml

from blog import gemtext


def migrate(from_: pathlib.Path, to: pathlib.Path):
    to.mkdir(parents=True, exist_ok=False)
    shutil.copytree(from_ / "content", to, dirs_exist_ok=True)
    shutil.copytree(from_ / "static" / "about", to / "about", dirs_exist_ok=True)

    laspelis = to / "laspelis"
    laspelis.mkdir()

    laspelis_index_lines = (from_ / "static" / "laspelis" / "index.gmi").read_text().splitlines()
    laspelis_index_lines = ["".join(l.split("/", 1)) for l in laspelis_index_lines]
    (to / "laspelis" / "index.gmi").write_text("\n".join(laspelis_index_lines) + "\n")

    for lp in (from_ / "static" / "laspelis").glob("*"):
        if lp.name == "index.gmi":
            continue
        shutil.copy(lp / "mail", laspelis / f"{lp.name}.mail")
        shutil.copy(lp / "index.gmi", laspelis / f"{lp.name}.gmi")

    (to / "about" / "index.gmi").replace(to / "about.gmi")
    (to / "about").rmdir()

    # Make links relative
    for g in to.glob("**/*.gmi"):
        path_in_site = g.relative_to(to)

        lines = g.read_text().splitlines()
        for i, l in enumerate(lines):
            if not l.startswith("=> "):
                continue
            l = l.removeprefix("=> ")
            url, *rest = l.split(maxsplit=1)

            ABSOLUTE_BLOG = "gemini://alex.corcoles.net/"
            if url.startswith(ABSOLUTE_BLOG):
                url = url.removeprefix(ABSOLUTE_BLOG)
                url = url.removesuffix("/")
                url = "../" * (len(path_in_site.parts) - 1) + url
                gemini_link = " ".join((f"=> {url}", " ".join(rest)))
                lines[i] = gemini_link
                continue

            ABSOLUTE_LASPELIS = "/laspelis/"
            if url.startswith(ABSOLUTE_LASPELIS):
                url = "../" * (len(path_in_site.parts) - 1) + url[1:]
                gemini_link = " ".join((f"=> {url}", " ".join(rest)))
                lines[i] = gemini_link
                continue

        reconstruct = "\n".join(lines)
        if not reconstruct.endswith("\n"):
            reconstruct += "\n"
        g.write_text(reconstruct)

    # Build old URL slash removal redirect list
    redirections = textwrap.dedent("""
    # This is a list of the pre-migration URLs of this blog.
    # URLs in this list might had been linked with a trailing slash.
    # Use Apache httpd's RewriteMap to preserve only old URLs
    """).lstrip()
    for g in to.glob("**/*.gmi"):
        url = str(g.relative_to(to).with_suffix(""))
        redirections += f"{url}/ {url}\n"
    pathlib.Path(to / "redirections.txt").write_text(redirections)


def build(from_: pathlib.Path, to: pathlib.Path):
    TITLE = "El blog es mío"
    SUBTITLE = "Hay otros como él, pero este es el mío"

    to.mkdir(parents=True, exist_ok=False)
    shutil.copytree(from_, to, dirs_exist_ok=True)

    dated_entries = [b for b in to.glob("**/*.gmi") if re.match(r"\d{4}-\d{2}-\d{2}", b.read_text().splitlines()[1])]
    dated_entries.sort()
    dated_entries.reverse()

    # Generate index.gmi
    index = textwrap.dedent(f"""
    # {TITLE}

    {SUBTITLE}

    Envíame email a alex arroba corcoles punto net.

    """).lstrip()
    for e in dated_entries:
        title, date, *_ = e.read_text().splitlines()
        title = title.removeprefix("# ")
        index += f"=> {'/'.join(e.parts[-3:]).removesuffix('.gmi')} {date} {title}\n"

    (to / "index.gmi").write_text(index)


    # Convert to HTML
    for gmi in to.glob("**/*.gmi"):
        html = gmi.with_suffix(".html")
        title = None
        if gmi.relative_to(to).parts[0] == "laspelis":
            title = "laspelis"
            if gmi.name != "index.gmi":
                subject = gmi.read_text().splitlines()[3]
                assert subject.startswith("Subject: "), subject
                title = subject.removeprefix("Subject: ")
        html.write_text(gemtext.convert(gmi.read_text(), title, ("feed/", TITLE) if gmi.relative_to(to) == pathlib.Path("index.gmi") else None))

    # Generate RSS
    fg = feed.FeedGenerator()
    fg.title(TITLE)
    fg.subtitle(SUBTITLE)
    fg.link(href="https://alex.corcoles.net", rel="self")

    for e in reversed(dated_entries[0:10]):
        title, date, *_ = e.read_text().splitlines()
        title = title.removeprefix("# ")
        path = "/".join(e.parts[2:]).removesuffix('.gmi')

        fe = fg.add_entry()
        url = f"https://alex.corcoles.net/{path}"
        fe.link(href=url)
        fe.published(
            datetime.datetime.combine(
                datetime.date.fromisoformat(date),
                datetime.datetime.min.time(),
                tzinfo=datetime.UTC,
            )
        )
        fe.title(title)
        fe.content(b"\n".join(list(map(lxml.html.tostring, lxml.html.document_fromstring(e.with_suffix(".html").read_bytes()).body[2:]))), type="html")
    feed_dir = to / "feed"
    feed_dir.mkdir()
    (feed_dir / "index.rss").write_bytes(fg.rss_str(pretty=True))


def main() -> None:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(required=True)

    subparser = subparsers.add_parser("migrate")
    subparser.add_argument("from_", type=pathlib.Path)
    subparser.add_argument("to", type=pathlib.Path)
    subparser.set_defaults(command=migrate)

    subparser = subparsers.add_parser("build")
    subparser.add_argument("from_", type=pathlib.Path)
    subparser.add_argument("to", type=pathlib.Path)
    subparser.set_defaults(command=build)

    args = vars(parser.parse_args())
    command = args.pop("command")
    command(**args)
