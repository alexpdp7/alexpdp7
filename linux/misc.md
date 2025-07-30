# Misc

## Reverse sshfs

https://blog.dhampir.no/content/reverse-sshfs-mounts-fs-push

You need the SFTP server program on your local machine (on Debian, the `openssh-server` package) and sshfs on the remote machine.

## Find non-Debian packages

```
aptitude search '~S ~i !~ODebian'
```
