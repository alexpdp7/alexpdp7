# Misc

## Reverse sshfs

https://blog.dhampir.no/content/reverse-sshfs-mounts-fs-push

You need the SFTP server program on your local machine (on Debian, the `openssh-server` package) and sshfs on the remote machine.

## Find non-Debian packages

```
aptitude search '~S ~i !~ODebian'
```

## Memory usage queries

### systemd

```
systemd-cgtop -m
```

Drill down with:

```
systemd-cgtop -m user.slice/user-1000.slice
```

### smem

```
sudo smem -P beam.smp -kta
```

## Quick rerouting of browser traffic through another host

`ssh -D 1234 host` creates a Socks proxy on `localhost:1234` that sends traffic through `host`.

By enabling "allow extension to control proxy settings" in the [multi account containers](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/) Firefox add-on, you can make containers use specific proxies.
