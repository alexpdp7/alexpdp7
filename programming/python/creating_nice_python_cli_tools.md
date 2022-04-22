Following this advice can make your tools easy to install by others, pleasant to use, robust, cross-platform, and powerful.

* Use [my suggestions for setting up Python projects](project_setup), particularly:
  * Provide instructions for installing your tool using [pipx](https://github.com/pypa/pipx).
    Using pipx, people can install and upgrade your script using a simple command that requires no administrative privileges (but it requires having Python and pipx installed).
  * As you are using [poetry](https://python-poetry.org/), following the indications above:
    * Use [Poetry's support for specifying scripts](https://python-poetry.org/docs/pyproject/#scripts), so when installing your tool via pipx or other means, your scripts are added to the user's path.
    * Dependencies you define will be installed automatically along with your application.
      This reduces the effort users need to use your application if you need third-party libraries.
      However, I would still advise to avoid unnecessary dependencies (for simple HTTP requests you can use the base library. If you do complex requests, then using a third-party library might be much simpler).
      As you are using pipx, those dependencies will be installed to a isolated virtualenv, so they will not interfere with anything on your system.
    * As your application is properly packaged, you can split your code into different Python files and use imports without issues.
* If your application requires secrets, such as credentials or others, consider using:
  * The standard [getpass](https://docs.python.org/3/library/getpass.html) module.
    This prompts for a string on the command line, hiding what the user types.
  * The [keyring](https://pypi.org/project/keyring/) library.
    This stores secrets using your operating system facilities.
* Use the [appdirs](https://pypi.org/project/appdirs/) library to obtain "user paths", such as the users directory for configuration, cache, or data.
  appdirs knows the proper paths for Linux, macOS and Windows.
  So for example, if your tool caches files and uses appdirs to find the cache directory, you might gain benefits such as cache files being excluded from backups.
* If your tool requires significant time to complete a process:
  * Use the [tqdm](https://tqdm.github.io/) library to add a progress bar.
  * But also consider using the standard [concurrent.futures](https://docs.python.org/3/library/concurrent.futures.html) module to add parallelism if you can.
    The [map](https://docs.python.org/3/library/concurrent.futures.html#concurrent.futures.Executor.map) function is particularly easy to use.
    Use it with a [ThreadPoolExecutor](https://docs.python.org/3/library/concurrent.futures.html#concurrent.futures.ThreadPoolExecutor) if the parallel tasks are IO-bound or invoke other programs, or with [ProcessPoolExecutor](https://docs.python.org/3/library/concurrent.futures.html#processpoolexecutor) if they perform significant CPU work in Python (to avoid the [GIL](https://wiki.python.org/moin/GlobalInterpreterLock)).
  * Consider using the standard [logging](https://docs.python.org/3/library/logging.html) module with a format that uses a timestamp, so users can inspect how much time is spent in different parts of the program.
    You can also use logging module to implement flags such as `--debug` and `--verbose`.
* Although you can use other fancier tools for parsing command-line arguments, the standard [argparse](https://docs.python.org/3/library/argparse.html) module is good enough for most tools.
  It has decent support for [sub-commands](https://docs.python.org/3/library/argparse.html#sub-commands), and the linked document describes a very nice pattern to define functions for sub-commands, under "One particularly effective way of handling sub-commands..."
  Try to provide help texts for parameters that may not be obvious.
  argparse supports a lot of different argument types, such as enumerated options, integers, file names, and others, that provide a lot of functionality out of the box.
* Remember that the standard [json](https://docs.python.org/3/library/json.html) module is built-in.
  You can use it to add a mode to your tool that generates JSON output instead of human-readable output, for easy automation of your tool, maybe using [jq](https://stedolan.github.io/jq/) or [fx](https://github.com/antonmedv/fx).
* Use the standard [subprocess](https://docs.python.org/3/library/subprocess.html) module to execute other commands.
  * Remember never to use `shell=True`, so among other things, your tool will work correctly with files using spaces in their names.
  * Use `check=True` so if the subprocess fails, an exception will be raised.
    This is likely the best default behavior, although the error is a bit ugly, this normally prevents ugly problems and it's a safe option.


You can find examples for many of those techniques in my [repos](https://github.com/alexpdp7?tab=repositories&q=&type=&language=python&sort=).
