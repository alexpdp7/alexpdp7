# Git advice

## Never use `git commit -m`, use `git commit -v`

Configure your system so that `git commit` opens your preferred editor.

With `git commit -v` you can see your commit diff while writing your commit message.
This helps you review that your commit is correct and write a better commit message.

## Use gitignore properly

See <https://git-scm.com/docs/gitignore>.

Note that by default, Git defaults to `$XDG_CONFIG_HOME/git/ignore` or `$HOME/.config/git/ignore`.

## Use the modern Git commands (or teach them)

Particularly, `git checkout` has many functionalities that now can be handled by more focused commands like `git switch` and `git reset`.

If you have too much muscle memory and are used to them, then consider learning them only to teach other people so that they start with the safer commands.

Many Git commands print suggestions that use the newer commands.
