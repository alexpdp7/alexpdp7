# WSL

## Opening links in a Windows browser

Create `~/.local/bin/x-www-browser` with the following content:

```
#!/bin/sh

/mnt/c/Windows/explorer.exe "$@"
true # ignore exit code so xdg-open works correctly
```

Ensure that the file is executable.

`xdg-open` uses `x-www-browser`.

## Issues with GUI apps

* [Uninstall `xdg-desktop-portal` if graphical applications seemingly block on startup](https://github.com/microsoft/wslg/issues/1273#issuecomment-2238745415).
