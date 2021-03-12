#!/usr/bin/env python3
import os
import shutil


def build():
    shutil.rmtree("build", ignore_errors=True)
    os.makedirs("build/gmi")

    for directory, _, files in os.walk("content"):
        for file in files:
            if file.endswith("gmi"):
                new_dir = f"build/gmi/{directory[8:]}"
                os.makedirs(new_dir, exist_ok=True)
                shutil.copyfile(f"{directory}/{file}", f"{new_dir}/{file}")
            else:
                # FIXME
                pass


if __name__ == "__main__":
    build()
