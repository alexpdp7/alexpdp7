#!/usr/bin/env python3
import pathlib
import subprocess
import sys

content = pathlib.Path(sys.argv[1])

print("Generating footers...")

CONTACT = {
    "es": "Envíame email a alex arroba corcoles punto net.",
    "en": "Send me email at alex at corcoles dot net.",
}

EDIT_IN_GITHUB = {
    "es": "Edita esta página.",
    "en": "Edit this page.",
}

PARENT = {
    "es": "Subir.",
    "en": "Go to parent."
}

ENGLISH_PAGES = ('about.gmi', 'gemini.gmi',)

content_gmi_files = [str(p.relative_to(content)) for p in pathlib.Path(content).glob("**/*.gmi")]

for gmi in pathlib.Path.cwd().glob("**/*.gmi"):
    relative_gmi = str(gmi.relative_to(pathlib.Path.cwd()))
    if relative_gmi == "index.gmi":
        # index.gmi is endless, no footer for that one
        continue

    language = "en" if relative_gmi in ENGLISH_PAGES or relative_gmi.startswith("notes/") else "es"

    footer = []

    footer.append(CONTACT[language])

    content_source = None
    if relative_gmi in content_gmi_files:
        content_source = "blog/content/" + relative_gmi

    if relative_gmi == "notes/interesting-projects.gmi":
        content_source = "interesting-projects/interesting-projects.gmi"

    if content_source:
        footer.append(f"=> https://github.com/alexpdp7/alexpdp7/edit/master/{content_source} {EDIT_IN_GITHUB[language]}")

    closest_index = gmi.with_name("index.gmi")
    while closest_index == gmi or closest_index.is_relative_to(pathlib.Path.cwd()) and not closest_index.exists():
        closest_index = closest_index.parent.parent / "index.gmi"

    closest_index = closest_index if closest_index.exists() else None
    if closest_index:
        index_link = "/".join([".."] * (len(gmi.parts) - len(closest_index.parts))) + "/"
        footer.append(f"=> {index_link} {PARENT[language]}")

    gmi_content = gmi.read_text()
    assert gmi_content.endswith("\n"), f"{gmi} has no trailing new line"
    assert not gmi_content.endswith("\n\n"), f"{gmi} has extra empty blank line"
    gmi.write_text(gmi_content + "\n" + "\n".join(footer) + "\n")
