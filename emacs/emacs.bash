# source this file from your bash startup script

test -f /usr/bin/emacs && {
    alias emacs="emacsclient --create-frame -t"
    export ALTERNATE_EDITOR=""
    export EDITOR="emacsclient -t"
}

test -f ~/.local/bin/emacs && {
    alias emacs="emacs --emacs-appimage-run-as emacsclient --create-frame -t"
    export ALTERNATE_EDITOR=""
    export EDITOR="emacs --emacs-appimage-run-as emacsclient -t"
}
