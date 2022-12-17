= Proxmox

== Networking

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
