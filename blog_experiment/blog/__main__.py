import argparse
import logging
import sys

from bicephalus import main as bicephalus_main
from bicephalus import otel
from bicephalus import ssl

import blog


def main():
    otel.configure_logging(logging.INFO)

    parser = argparse.ArgumentParser()
    parser.add_argument("--key-cert", nargs=2, metavar=("KEY", "CERT",), help="Path to a key and a file")
    args = parser.parse_args()

    if args.key_cert:
        key, cert = args.key_cert
        with ssl.ssl_context_from_files(cert, key) as ssl_context:
            bicephalus_main.main(blog.handler, ssl_context, 8000)
        sys.exit(0)

    with ssl.temporary_ssl_context("localhost") as ssl_context:
        bicephalus_main.main(blog.handler, ssl_context, 8000)
    sys.exit(0)

if __name__ == "__main__":
    main()
