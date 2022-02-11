# My personal infrastructure

* Hetzner auction server: 48Gb RAM, 2x2Tb HDD. Runs Proxmox, tinc/ocserv, Apache as reverse proxy
  * LXC container running NextCloud
  * LXC container running Miniflux
  * LXC container running bitwarden_rs
  * LXC container running an acquaintance's Twitter bot
  * LXC container running Dokku, hosting a few personal apps
  * LXC container running FreeIPA replica
  * LXC container running Nagios
  * LXC container running Grafana
  * LXC container running Ipsilon
  * LXC container running PostgreSQL
  * LXC container running a workstation
  * LXC container running Gitolite
  * LXC container running FreeSWITCH
* Flat 1
  * HP Proliant Microserver: 4Gb RAM, 2x4Tb HDD
    * DHCP/DNS
    * Runs SMB/NFS
    * ZFS backups on external USB drives
    * tinc/ocserv
  * Raspberry Pi (1Gb RAM) running LibreElec + TVHeadend, records to NFS share on HP server
* Flat 2
  * Raspberry Pi (1Gb RAM) running Rocky Linux, runs DHCP/DNS, tinc/ocserv
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
It provides a user directory and centralized auth, with passwordless single-sign on.
It also has sudo integration, so I can sudo on all systems with a single password.

Many systems and services are integrated in FreeIPA.
My laptop is joined to the domain so I can even log in to some web applications without typing a password.

Ipsilon adds SAML for some applications which do not support Kerberos.

Ipsilon is backed by Red Hat, although they seem to have shifted their focus to KeyCloak. KeyCloak is much more featureful, but I prefer Ipsilon because:

* It's deployed via RPM
* Integration with FreeIPA is a one-liner
* It's still used by the Fedora Project infrastructure

FreeIPA and Ipsilon are running in CentOS 7- I will probably reconsider this stack around 2024 when CentOS gets close to EOL.

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

https://github.com/alexpdp7/ansible-create-proxmox-host
https://github.com/alexpdp7/ansible-create-proxmox-centos7-ipa

I also use Ansible for some orchestration tasks (such as deploying FreeIPA replicas, handling Letsencrypt certificates, etc.).

I use an Ansible playbook using https://github.com/alexpdp7/ansible-puppet/ to run Puppet to configure individual systems.

### Operating systems

I use:

* Proxmox, as it provides LXC containers (and VMs if needed) and ZFS storage. I like ZFS for its protection about bitrot, and because send/recv and snapshots are great for backups
* EL7/EL8, due to the long life cycle and stability. Due to the CentOS 8 life cycle changes, I'm switching CentOS 8 hosts to Rocky Linux, while CentOS 7 remains.
* Rocky Linux for my server Raspberry.
* LibreElec for my mediacenter Raspberry. Common distros are not an option, as they don't support hardware video acceleration. LibreElec sets up everything I need with minimal fuss, so while it's the system that doesn't use configuration management, it works fine.

### Software updates

I use `yum-cron` on EL7, `dnf-automatic` on EL8 and `unattended-upgrades` on Debian/Ubuntu so updates are automatically installed.

`ragent` monitors when systems need a reboot and warns me through Nagios.

### Packaging

* https://github.com/alexpdp7/bitwarden_rs/tree/rpm / https://copr.fedorainfracloud.org/coprs/koalillo/bitwarden_rs/
* https://github.com/alexpdp7/nextcloud-rpm / https://copr.fedorainfracloud.org/coprs/koalillo/nextcloud/

## Storage

I run Nextcloud on an LXC container, files are stored in a ZFS filesystem.

Media and other non-critical files are stored in the Proliant and shared via Samba and NFS.

### Media

I run a Jellyfin server on the Proliant to serve media to phones, a MiBox and a Raspberry running LibreElec.

The Raspberry has a DVB-T tuner and TVHeadend, recordings are stored on the Proliant in an NFS share.

### Backup

Valuable data is on dedicated datasets. Each Proxmox host (the Proliant and the Hetzner server) run scripts daily that create snapshots.

The Hetzner server sends/receives datasets to the Proliant daily.

I send/receive datasets from the Proliant to USB drives using ZFS.

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

Dokku is its own special system. It could be replaced completely with Kubernetes, but with additional complexity.

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

## My blog

I was never a fan of Wordpress (I prefer other platforms to PHP and MySQL), Remi maintains very up to date EPEL 7 packages. Remi also maintains some packages for EL 8 (derived from Remi's own packages in Fedora, hosted on Remi's personal repositories).

However, after reading about Geminispace, I decided to port my blog to Geminispace and skip migrating from EL 7 to EL 8. Right now I run some custom scripts that generate a static blog and serves them using Agate in my workstation container. I run a Kineto proxy on Dokku that makes the content available through conventional HTML/HTTP. See details at:

https://github.com/alexpdp7/gemini_blog

## Phones

I wanted to eliminate my landlines, because I get a ton of spam there.
However, I need to provide calls between my home and another home using physical phones (people like wireless headsets- smartphones are not really well designed for extended phone calls).

The key to this is the SIP protocol.
You can get classical phones that work using the SIP protocol, or ATA devices that turn a regular phone into a SIP phone.

I installed FreeSWITCH from the [OKay repo](https://okay.network/blog-news/rpm-repositories-for-centos-6-and-7.html).
FreeSWITCH comes with a fairly complete default configuration.
By default it will set up extensions in the 1000...1020 range, with a configurable single password for all extensions, plus some extensions for test calls, etc.

The major difficulty in setting a SIP server is networking.
I run FreeSWITCH in an LXC container on Proxmox.
I expose the SIP server's SSL TCP port to the Internet, plus a range of UDP ports, using iptables.
(I consulted some SIP forums, and apparently there are no major hardening requirements in exposing a SIP server to the Internet, although I think maybe it's better to use a SIP proxy.)
You can also use STUN/TURN servers, but I had lots of trouble getting that set up.
Also by default, FreeSWITCH figures out a public IP- if you want to get FreeSWITCH working behind a VPN, you need to disable that.

For the phones, I bought and set up two Grandstream HT801 ATA devices.
Those are quite cheap (around 40€), but they are quite fancy professional network devices, with a rough but featureful UI (they can do OpenVPN, SNMP, etc.).
They connect directly to FreeSWITCH over the Internet, autoconfiguring via DHCP, so in theory they could work anywhere in the world with a network connection.
After configuration and assigning an extension, you only need to connect cheap wireless phones to them, and start making calls with the 1000...1020 extensions.

For testing and occasional calls I use [Baresip](https://github.com/baresip/baresip) from F-Droid in my smartphone, and from Debian in my laptop.
For smartphones, SIP has the drawback that it requires a persistent connection to the SIP server to receive calls- thus draining the battery a bit.
Some SIP setups use push notifications to get around that, but that seemed to be complex.
So the only devices that are connected 24/7 are the ATAs, I use my smartphone and my laptop occasionally.

SIP allows many other interesting stuff such as:

* Instant messaging
* Videoconferencing
* Advanced phone features (conferences, barging in, voicemail, automation)

So you can do real fancy stuff with it, but I haven't looked at it, because really I just need calls over two households on physical classical wireless handsets.

## Possible improvements

* Better sync'ing of user files. NextCloud out of the box only works on systems with a graphical interface. There are solutions to mount NextCloud using WebDav, but I prefer to do a sync (so if the server is down I still can access my files) and to run the client headless, but I prefer to stay within supported solutions. Probably syncthing would be a good solution for headless systems to sync dotfiles, etc.
* Add a lab so I can experiment with things in isolated environments.
* Set up SSO on my smartphone, perhaps do some MDM
