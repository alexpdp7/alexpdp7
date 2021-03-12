#!/usr/bin/env python3
import os
import re
import shutil


def fix():
    shutil.rmtree("content", ignore_errors=True)
    os.makedirs("content")

    for directory, _, files in os.walk("md"):
        for file in files:
            if file.endswith("gmi"):
                new_dir = f"content/{directory[3:]}"
                with open(f"{directory}/{file}", "r") as old_file:
                    old_content = old_file.read()
                old_content_lines = old_content.splitlines()

                meta_line = old_content_lines[2]
                match = re.fullmatch(r'''title: "([^"]*)" date: "(....-..-..)" categories:''', meta_line)
                title = match.group(1)
                date = match.group(2)

                separator_line = old_content_lines[1:].index('-'*80) + 1

                content = f"# {title}\n"
                content += f"{date}\n"
                content += "\n".join(old_content_lines[separator_line + 1:])

                os.makedirs(new_dir, exist_ok=True)
                with open(f"{new_dir}/{file}", "w") as new_file:
                    new_file.write(content)
            else:
                # FIXME
                pass


if __name__ == "__main__":
    fix()
