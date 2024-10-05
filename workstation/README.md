I am trying to move some tools into a [container image](build_workstation) for use with Distrobox, and [a Python module with tools](../scripts).

This includes:

* [My editor](../emacs)
* [A modern IRC setup](modern_irc.md).
* [mbsync to synchronize my email for backup](../scripts/p7s/mail/mbsync.py)
* [Some integration with vaultwarden for secrets](../scripts/p7s/bitwarden.py)
* And some other odds and ends (NextCloud, etc.)

Checklist:

* DNIe
* Emacs
* sys2 (Ansible, `talosctl`, `kubectl`)
* PaperWM
* Nextcloud
* Bitwarden
* Senpai
* ZFS (for backups)
* FreeIPA client
* Email client

# Debian setup

* Remove CD apt source
* Join FreeIPA with Gnome initial setup.
* Enable SSH root login.
* Change root password, sync with inventory and Bitwarden.
* Provision with Ansible

```
bw config server https://bitwarden.pdp7.net/
bw login
bw list items --search firefox
```

; to configure Firefox Sync.
