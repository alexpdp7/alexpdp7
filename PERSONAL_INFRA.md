# My personal infrastructure

* OVH 2Gb RAM VPS running FreeIPA (also tinc/ocserv)
* Hetzner auction server: 48Gb RAM, 2x2Tb HDD. Runs Proxmox, tinc/ocserv, Apache as reverse proxy
  * LXC container running FreeIPA replica
  * LXC container running Nagios
  * LXC container running NextCloud
  * LXC container running Grafana
  * LXC container running Ipsilon
  * LXC container running my Wordpress blog
  * LXC container running PostgreSQL
  * LXC container running a workstation
  * VM running Jenkins, Gitolite
  * VM running Discourse
  * VM running Dokku
* Flat 1
  * HP Proliant Microserver: 4Gb RAM, 2x4Tb HDD
    * DHCP/DNS
    * Runs SMB/NFS
    * ZFS backups on external USB drives
    * tinc/ocserv
  * Raspberry Pi running LibreElec + TVHeadend, records to NFS share on HP server
* Flat 2
  * Raspberry Pi running Raspbian, runs DHCP/DNS, tinc/ocserv

## Networking

I like having working DNS, so I run dnsmasq on both flats and for the Proxmox network on the Hetzner server.
It also does integrated DHCP (mostly everything gets a DHCP IP and thus, a hostname).
Every environment has a /24 network with DNS/DHCP and their own domain (hetzner.int.mydomain, flat1.int.mydomain, etc.).
I've set up SRV records so DNS resolution works across networks (even reverse DNS).
I join all networks using tinc in a mesh.

On every network I've also set up ocserv to provide remote access if I'm outside these networks; I can pick the closest access point and reach my entire network.

## Authentication

I run a two-node FreeIPA cluster.
It provides a user directory and centralized auth, with paswordless single-sign on.
It also has sudo integration, so I can sudo on all systems with a single password.

Many systems and services are integrated in FreeIPA.
My laptop is joined to the domain so I can even log in to some web applications without typing a password.

Ipsilon adds SAML for some applications which do not support Kerberos.

## Monitoring

I run Nagios monitoring all hosts and services.
I get alerts for hosts and services being down.
I monitor some stuff like Nextcloud updates using Nagios and cron jobs.
I use https://github.com/alexpdp7/ragent as the monitor, which also means I get notifications when a host is updated and requires a reboot.

## Configuration management

I use Ansible playbooks to provision VMs on Proxmox.
I also use Ansible for some orchestration tasks (such as deploying FreeIPA replicas, handling Letsencrypt certificates, etc.).

I use an Ansible playbook using https://github.com/alexpdp7/ansible-puppet/ to run Puppet to configure individual systems.
