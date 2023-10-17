import os
import sys


def main():
    os.execvp("autossh", ["autossh", "-M", "0", "-t"] + sys.argv[1:] + ["screen -RdU"])
