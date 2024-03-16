Some simple advice for people who are starting to use ssh.

# Use the config

If you create a file `~/.ssh/config`, with contents like:

```
Host xxx
	HostName yyy
	Port 1234
  User zzz
```

, then if you type `ssh xxx`, the result will be like executing `ssh -p 1234 zzz@yyy`.

Any ssh command line arguments can be encoded in an SSH client configuration file, so you can access any server with a simple `ssh host` command, without any additional parameters.

Additionally, most modern systems configure SSH tab completion, so if you type `ssh <tab><tab>`, your shell will complete with the hosts in your configuration file.

# Use public key authentication

By default, ssh uses passwords for authentication.
If you use a good password, then password authentication is a decent authentication method.

However, you can use other methods, such as public key authentication.
With public key authentication, you have a public and private key.

If you are working on system A with your *private* key, and you copy your *public* key to system B, then you can ssh from system A to system B without entering a password.

## Security

Note that if someone obtains your private key, they will be able to log in to systems that trust your key.
Knowledge of your private key is similar to knowledge of a password.
Take care making your private key truly private.

If you suspect someone else has been able to obtain your private key, then generate a new key and remove the leaked public key from all systems.

Note that you can generate as many keys as you want.
Managing multiple keys requires more effort, but in some cases it might be more convenient.
For example, if a key is suspected to be leaked, then you might only need to revoke a key and continue using other keys.

## Generating SSH keys

To generate your private and public keys:

```
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/alex/.ssh/id_rsa): 
Created directory '/home/alex/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/alex/.ssh/id_rsa
Your public key has been saved in /home/alex/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:...
The key's randomart image is:
+---[RSA 3072]----+
...
```

## Key type choice

OpenSSH, the standard ssh client, [changed its default type of key generation to Ed25519 in version 9.5 released in late 2023](https://www.openssh.com/txt/release-9.5).
Previously, `ssh-keygen` generated RSA keys, as in the example above.
Many Linux distributions still use OpenSSH versions earlier than 9.5.

You can find advisories like [the following](https://www.ssh.com/academy/ssh/keygen):

> It is quite possible the RSA algorithm will become practically breakable in the foreseeable future. All SSH clients support this algorithm.

Although as of the time of writing this, RSA is considered safe.
However, you can consider generating an Ed25519 key instead, following the most recent OpenSSH defaults.

## Passphrases

By default, if you provide an empty passphrase to `ssh-keygen`, your private key will be stored unprotected.
Anyone that can read the private key file can obtain your key.

You can use a passphrase to protect your key.
If someone obtains a private key file but they don't know the passphrase, then they cannot use the key.

Using a passphrase means that you need to type the passphrase every time you use the key, or use a system such as `ssh-agent`.
This creates a tradeoff between security and convenience.

(Note that a popular criticism of SSH public key authentication is that it is not easy for systems administrators to enforce the use of SSH passphrases.)

# Further SSH features

Many developers have added many useful features to SSH during many years, such as:

* The `scp` command to transfer files using SSH
* Tunnels to establish bidirectional communication between systems without such connectivity.
  (For example, to connect to your workstation from a remote system.)
* Jump hosts that expedite the connection to a system that is not directly accessible, by using SSH to establish connection through intermediate systems.

Also, SSH integrates very well with UNIX pipes and tools such as rsync, Git, and many others.
