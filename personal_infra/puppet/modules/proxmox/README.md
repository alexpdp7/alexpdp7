# Proxmox

## Networking

Configures a public Internet IP, and an internal network with forwarding for containers and virtual machines.

Add the following to your Proxmox host Ansible variables:

```
network:
  ip: dotted.ip.notation
  netmask: 255.255.255.0
  gateway: dotted.ip.notation
  proxmox:
    ip: 10.3.3.1
    netmask: 255.255.255.0
    network: 10.3.3.0/24
```

## Proxy

Class `proxmox::proxy` can handle proxying internal web servers.

```
class {'proxmox::proxy':
  mail => lookup('mail.root_mail'),
  base_hostname => lookup('network.public_hostname'),
}
```

This uses the Apache HTTP Server and mod_md to obtain certificates.
Your hostname must be publicly accessible, because http challenges are used.

You receive mails to restart your server when required.
