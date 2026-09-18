#!/usr/bin/env python3
import pathlib
import sys

content = pathlib.Path(sys.argv[1])

print("Generating footers...")

CONTACT = {
    "es": "Envíame email a alex arroba corcoles punto net.",
    "en": "Send me email at alex at corcoles dot net.",
}

ENGLISH_PAGES = ('about.gmi', 'gemini.gmi',)


for gmi in pathlib.Path.cwd().glob("**/*.gmi"):
    relative_gmi = str(gmi.relative_to(pathlib.Path.cwd()))
    if relative_gmi == "index.gmi":
        # index.gmi is endless, no footer for that one
        continue
    language = "en" if relative_gmi in ENGLISH_PAGES or relative_gmi.startswith("notes/") else "es"
    footer = [CONTACT[language]]
    gmi_content = gmi.read_text()
    assert gmi_content.endswith("\n"), f"{gmi} has no trailing new line"
    assert not gmi_content.endswith("\n\n"), f"{gmi} has extra empty blank line"
    gmi.write_text(gmi_content + "\n" + "\n".join(footer) + "\n")
