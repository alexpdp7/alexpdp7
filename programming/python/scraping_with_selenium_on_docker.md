Create a virtualenv and install `testcontainers` with `selenium` support:

```
$ python3 -m venv selenium_testcontainers_venv
$ . selenium_testcontainers_venv/bin/activate
$ pip install -U pip
$ pip install testcontainers[selenium]
```

Use in a Python terminal:

```
$ python
>>> from testcontainers import selenium
>>> from selenium.webdriver import DesiredCapabilities
>>> chrome = selenium.BrowserWebDriverContainer(DesiredCapabilities.CHROME)
>>> chrome.start()
>>> webdriver = chrome.get_driver()
>>> ...
```

Use in code:

```
from testcontainers import selenium
from selenium.webdriver import DesiredCapabilities

with BrowserWebDriverContainer(DesiredCapabilities.CHROME) as chrome:
    webdriver = chrome.get_driver()
    ...
```
