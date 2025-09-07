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

## Email forwarding via IMAP

When you have multiple email addresses, you have multiple options to use them.

Traditionally, people used redirection/forwarding to make email arriving at `from@example.com` go to `to@example.net` instead.

If mail from `example.com` and `example.net` is handled by different servers, typically you can configure the `example.com` mail server to resend any message arriving to the `from` address to `to@example.net`.

However, nowadays with spam filtering, the `example.net` mail server can reject these emails as spam, sometimes silently.

For safer redirects, you can:

* Use the same mail server for both accounts.
  However, this sometimes cannot be done or has extra cost and complexity.

* Configure the destination email server to fetch email from the origin mail server.
  For example, Gmail can do this, but the fetching period can be as long as 15 minutes.
  This can be inconvenient when receiving confirmation emails, etc.

  Additionally, operators of the destination email server now have your credentials.

A third option is to run this fetching process yourself.

<https://github.com/lefcha/imapfilter> supports connecting to an IMAP account, waiting until messages to arrive, and moving them to another IMAP account.

Benefits:

* IMAPFilter can use IMAP idle to request the IMAP server to notify when messages arriving, so forwarding happens without a polling delay.
* Because IMAP is used on both sides, no spam filtering happens.
* IMAPFilter is [packaged for many distributions](https://repology.org/project/imapfilter/versions).

Drawbacks:

* Requires additional infrastructure.
* If IMAPFilter stops working, email stops being forwarded without warning.

Refer to [this Python module](../scripts/p7s/mail/__init__.py) for scripts that configure IMAPFilter as a systemd service, with credentials from Bitwarden.
