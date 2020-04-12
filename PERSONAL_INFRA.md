# My personal infrastructure

* Hetzner auction server: 48Gb RAM, 2x2Tb HDD. Runs Proxmox, tinc/ocserv, Apache as reverse proxy
  * LXC container running NextCloud
  * LXC container running my WordPress blog
  * LXC container running an acquaintances Twitter bot
  * VM running Dokku, hosting a few personal apps
  * VM running a Discourse forum
  * LXC container running FreeIPA replica
  * LXC container running Nagios
  * LXC container running Grafana
  * LXC container running Ipsilon
  * LXC container running PostgreSQL
  * LXC container running a workstation
  * LXC container running Gitolite
* Flat 1
  * HP Proliant Microserver: 4Gb RAM, 2x4Tb HDD
    * DHCP/DNS
    * Runs SMB/NFS
    * ZFS backups on external USB drives
    * tinc/ocserv
  * Raspberry Pi running LibreElec + TVHeadend, records to NFS share on HP server
* Flat 2
  * Raspberry Pi running Raspbian, runs DHCP/DNS, tinc/ocserv
* OVH 2Gb RAM VPS running FreeIPA (also tinc/ocserv)

## Networking

I like having working DNS, so I run dnsmasq on both flats and for the Proxmox network on the Hetzner server.
It also does integrated DHCP (mostly everything gets a DHCP IP and thus, a hostname).
Every environment has a /24 network with DNS/DHCP and their own domain (hetzner.int.mydomain, flat1.int.mydomain, etc.).
I use Route 53 for DNS records (except those of my own networks). DNS records are created with Ansible playbooks.

I have the following snippets on dnsmasq's configuration:

```
server=/flat1.mydomain/ip.of.flat1.dns
rev-server=net.mask.of/flat1,ip.of.flat1.dns
```

So one dnsmasq instance can lookup records (even reverse DNS) on the other dnsmasq instances, so I can address systems on other networks by their name.
This could also be achieved by NS records, if I'm not mistaken, but this way everything is private on my own dnsmasq servers and not on public DNS.

I join all networks using tinc in a mesh. Tinc keys are generated and distributed using an Ansible playbook.

On every network I've also set up ocserv to provide remote access if I'm outside these networks; I can pick the closest access point and reach my entire network.

## Authentication

I run a two-node FreeIPA cluster.
It provides a user directory and centralized auth, with paswordless single-sign on.
It also has sudo integration, so I can sudo on all systems with a single password.

Many systems and services are integrated in FreeIPA.
My laptop is joined to the domain so I can even log in to some web applications without typing a password.

Ipsilon adds SAML for some applications which do not support Kerberos.

## Mail

All systems are running Postfix configured to send emails through an account on my free G Suite account.
This way I get notifications on failed cronjobs or automated updates.

## TLS

I set up certificates using certbot-route53 on Ansible playbooks.
DNS verification allows me to run TLS on non-reachable hosts.

I run the playbooks from my workstation periodically to renew certificates.

## Monitoring

I run Nagios monitoring all hosts and services.
I get alerts for hosts and services being down.
I use https://github.com/alexpdp7/ragent as the monitor, which also means I get notifications when a host is updated and requires a reboot.

To monitor certain things, such as FreeIPA, I set up cronjobs which run health checks and drop the output somewhere in `/var/www/html/*`, which then I check using check_http.

I also run Netdata on many hosts, which I can access via a reverse proxy at https://netdata.mydomain/$HOSTNAME with single sign on.

## Configuration management

I use Ansible playbooks to provision VMs and LXC containers on Proxmox.
The playbooks add the new hosts automatically to FreeIPA, set up SSH, etc. See:

https://github.com/alexpdp7/ansible-create-proxmox-vm-ubuntu1604-ipa
https://github.com/alexpdp7/ansible-create-proxmox-centos7-ipa

I also use Ansible for some orchestration tasks (such as deploying FreeIPA replicas, handling Letsencrypt certificates, etc.).

I use an Ansible playbook using https://github.com/alexpdp7/ansible-puppet/ to run Puppet to configure individual systems.

### Software updates

I use `yum-cron` on CentOS and `unattended-upgrades` on Debian/Ubuntu so updates are automatically installed.

`ragent` monitors when Debian/Ubuntu systems need a reboot and warns me through Nagios.

## Storage

I run Nextcloud on an LXC container, files are stored in a ZFS filesystem.

Media and other non-critical files are stored in the Proliant and shared via Samba and NFS.

### Media

I run a Jellyfin server on the Proliant to serve media to phones, a MiBox and a Raspberry running LibreElec.

The Raspberry has a DVB-T tuner and TVHeadend, recordings are stored on the Proliant in an NFS share.

### Backup

Systems with valuable data dump databases, etc. to `/srv/backup/$HOSTNAME/`. This is rsynced to the Proliant Microserver.

I have two external USB HDDs. Each one is a ZPOOL. I plug them in monthly and run a backup script that:

* rsyncs `/srv/backup` and local storage folders
* Uses zfs send/receive and snapshots to backup some ZFS filesystems (Nextcloud).
* Creates snapshots

## Dokku

I use Dokku to host a few personal applications, so I can update them with `git push`. I also have Ansible playbooks to set up the applications and handle some of them which have more complex deployments.

## Why not Docker/Kubernetes?

Delivering applications as Docker images is massively popular right now, so it's worth explaining why I'm running VMs and LXC containers and I'm not more container-driven.

#### Some things are not containerized

FreeIPA has some support for running in containers, but it doesn't seem to be the most recommended way of running it.
While it's not a "core" service, I don't think I have an alternative way to get some of its benefits (single users/passwords database across other services and systems, single-sign on, sudo management, etc.).
It looks like integrating Ipsilon with FreeIPA if Ipsilon is running in a container would not be easy/supported either.

WordPress has Docker images, but like the EPEL packages I use, they don't seem to be officially supported by Wordpress.
However, both seem to be well maintained, but EPEL packages are automatically updated using the same process than the rest of my systems (`yum-cron`).

I need to have non-container infrastructure in place, so I have the option of running additional things there or add the overhead of setting up container infrastructure on top.
Containerization has its advantages, so it's just an equation about how much you benefit from containers compared to the overhead of having container infrastructure.

#### Some containerized things are special

This is principally Discourse.
Discourse does some unique weird Docker stuff, so it doesn't seem to be supported/straightforward to throw it into Kubernetes nor I feel comfortable running more containers in its host (I could do that, but still I wouldn't get uniform management as Discourse is managed in a non-standard way).

Dokku is another thing which I feel is special. I could replace it wholesale with Kubernetes, I guess, but that would require more work as running Dokku is very simple (mostly because it lacks a lot of Kubernetes features, such as supporting multiple nodes).

So elements like those affect the previous equation; they don't fit in the "generic container infrastructure" and thus reduce its benefit.

#### Containerization infrastructure has its cost

There are lightweight ways to run containers; docker-compose, plain Docker, etc.
These require significant additional work to automate them to the level of my existing non-containerized infrastructure (automation, backups, etc.), but they consume little additional resources.
The cost analysis for those is that my existing automation works and the cost of re-implementing them makes them not worthwhile at this point.

Heavyweight solutions like Kubernetes tend to consume more resources, but have better automation features built-in.
The cost analysis for those is that with the money I'm spending now (single 48gb RAM Hetzner dedicated server) I wouldn't be able to run the same amount of stuff.
If I was running a significantly greater amount of stuff or I had high-availability requirements, then this would change.

#### Conclusion

If I was starting from scratch, perhaps a light-weight container solution would have been worthwhile, as some services might be easier to provide using a container approach. Also perhaps setting up the automation/etc. would be easier and would give me some advantages.

If I was running more services or had greater availability requirements, a cluster-ready solution like Kubernetes would probably be required.

In my current situation, with the work already performed, I don't think investing more in containers is the most effective use of my limited resources.

## Possible improvements

* Right now I execute backups in the Proliant, plugging in small USB HDDs. As I'm often away from flat 1, I'd like to re-do my backup scripts so I can plug in the USB drives in any system (e.g. my laptop, the Proliant in flat 1 or the Raspberry Pi on flat 2) and run the backup wherever I am.
* Convert the Proliant to Proxmox so it uses ZFS (for even simpler backups and snapshotting) and the few misc services there can run isolated in LXC containers.
* Find a way to run the stuff that relies on Docker (Dokku, Discourse) nested in an LXC container using ZFS in a "correct" way, so I can drop more VMs and have more density.
* Deploy a good virtual workstation. I'd like to have a persistent desktop I can use when I'm not at my laptop, where I can run overnight jobs, etc. My current LXC workstation works well, but I'd like to have a good graphical remote desktop solution.
* Better sync'ing of user files. NextCloud out of the box only works on systems with a graphical interface. There are solutions to mount NextCloud using WebDav, but I prefer to do a sync (so if the server is down I still can access my files) and to run the client headless, but I prefer to stay within supported solutions. Probably syncthing would be a good solution for headless systems to sync dotfiles, etc.
* Add a lab so I can experiment with things in isolated environments.
* Set up SSO on my smartphone, perhaps do some MDM
