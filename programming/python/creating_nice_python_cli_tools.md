* Use [my suggestions for setting up Python projects](project_setup), particularly:
  * Provide instructions for installing your tool using [pipx](https://github.com/pypa/pipx).
    Using pipx, people can install and upgrade your script using a simple command that requires no administrative privileges (but it requires having Python and pipx installed).
  * As you are using [poetry](https://python-poetry.org/), following the indications above:
    * Use [Poetry's support for specifying scripts](https://python-poetry.org/docs/pyproject/#scripts), so when installing your tool via pipx or other means, your scripts are added to the user's path.
    * Dependencies you define will be installed automatically along with your application.
      As you are using pipx, those dependencies will be installed to a isolated virtualenv, so they will not interfere with anything on your system.
* If your application requires secrets, such as credentials or others, consider using:
  * The standard [getpass](https://docs.python.org/3/library/getpass.html) module.
    This prompts for a string on the command line, hiding what the user types.
  * The [keyring](https://pypi.org/project/keyring/) library.
    This stores secrets using your operating system facilities.
* Use the [appdirs](https://pypi.org/project/appdirs/) library to obtain "user paths", such as the users directory for configuration, cache, or data.
  appdirs knows the proper paths for Linux, macOS and Windows.
  So for example, if your tool caches files and uses appdirs to find the cache directory, you might gain benefits such as cache files being excluded from backups.
* Use the [tqdm](https://tqdm.github.io/) library to add a progress bar if your tool requires significant time to complete a process.
* Although you can use other fancier tools for parsing command-line arguments, the standard [argparse](https://docs.python.org/3/library/argparse.html) module is good enough for most tools.
  It has decent support for [sub-commands](https://docs.python.org/3/library/argparse.html#sub-commands), and the linked document describes a very nice pattern to define functions for sub-commands, under "One particularly effective way of handling sub-commands..."
* Remember that the standard [json](https://docs.python.org/3/library/json.html) module is built-in.
  You can use it to add a mode to your tool that generates JSON output instead of human-readable output, for easy automation of your tool, maybe using [jq](https://stedolan.github.io/jq/) or [fx](https://github.com/antonmedv/fx).

You can find examples for many of those techniques in my [repos](https://github.com/alexpdp7?tab=repositories&q=&type=&language=python&sort=).
