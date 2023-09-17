import logging

from bicephalus import main as bicephalus_main
from bicephalus import otel
from bicephalus import ssl

import blog


def main():
    otel.configure_logging(logging.INFO)
    with ssl.temporary_ssl_context("localhost") as ssl_context:
        bicephalus_main.main(blog.handler, ssl_context, 8000)


if __name__ == "__main__":
    main()
