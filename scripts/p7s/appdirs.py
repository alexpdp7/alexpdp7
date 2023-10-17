import appdirs
import pathlib


APPDIRS = appdirs.AppDirs("p7s", "alex@pdp7.net")


def user_cache_dir():
    r = pathlib.Path(APPDIRS.user_cache_dir)
    r.mkdir(parents=True, exist_ok=True)
    return r
