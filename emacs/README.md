# Don't fear the Emacs

If you are here, you are probably thinking about adopting Emacs as your editor.
Perhaps you are facing analysis paralysis, wondering what's the best way to do it.

Just do it!
It's a bit alien at first, but I didn't need much time to do all my editing in Emacs.
I haven't learnt Emacs Lisp and I haven't adopted any large configuration package.

Start with the following `.emacs`:

```
(fido-vertical-mode)
(which-key-mode)
```

You can execute Emacs commands with `M-x` (alt-x).
`fido-vertical-mode` adds incremental search to `M-x`
You can learn many keybindings through the hints that the Emacs menu and `M-x` show.

When you pause after pressing an incomplete shortcut, `which-key-mode` shows the next keys and shortcuts available.
By pressing `C-x` (control-x), `C-c`, or `C-h, you can see the global, mode, and help shortcuts respectively.

[My `emacs.el` is about 120 lines](emacs.el).
Perhaps when you read this, my current config will be much bigger..
But I'm definitely happy today with my 120-line config.

Check [emacs.bash](https://github.com/alexpdp7/alexpdp7/blob/master/emacs/emacs.bash) for something you can source in your bash to keep Emacs running and prevent slow startup.
