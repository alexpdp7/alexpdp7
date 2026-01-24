import argparse
import pathlib
import shutil


def migrate(from_: pathlib.Path, to: pathlib.Path):
    to.mkdir(parents=True, exist_ok=False)
    shutil.copytree(from_ / "content", to, dirs_exist_ok=True)
    shutil.copytree(from_ / "static" / "about", to / "about", dirs_exist_ok=True)
    laspelis = to / "laspelis"
    laspelis.mkdir()
    for lp in (from_ / "static" / "laspelis").glob("*"):
        if not lp.is_dir():
            print("skipping", lp)
            continue
        shutil.copy(lp / "mail", laspelis / f"{lp.name}.mail")
        shutil.copy(lp / "index.gmi", laspelis / f"{lp.name}.gmi")


def main() -> None:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(required=True)

    subparser = subparsers.add_parser("migrate")
    subparser.add_argument("from_", type=pathlib.Path)
    subparser.add_argument("to", type=pathlib.Path)
    subparser.set_defaults(command=migrate)

    args = vars(parser.parse_args())
    command = args.pop("command")
    command(**args)
