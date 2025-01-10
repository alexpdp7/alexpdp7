# Using Yggdrasil/OpenNIC/YunoHost

This is research on doing "gratis" self-hosting.

* Yggdrasil is an overlay IPv6 network running on top of the Internet.
  All devices on Yggdrasil have a fixed IP address, no matter where in the Internet they are.
  The Yggdrasil IP address is reachable by other devices in the Yggdrasil network.

  This means that you do not need any public IP address to communicate between devices on Yggdrasil.

  Therefore, you do not need to pay for public IP addresses, and have some extra flexibility.
  (You can move a host between networks and you can continue to be reachable without dynamic DNS, etc.)

* OpenNIC is an alternate DNS root.
  Systems using OpenNIC servers can resolve hostnames on OpenNIC.

  Registering OpenNIC domains has no cost.

  Therefore, you do not need to pay a DNS domain.

* YunoHost provides easy installation of many popular self-hosted services.

## Notes

* The Debian README for Yggdrasil sets up a configuration without public peers.
  My testing hosts discovered each other only because they were on the same IPv4 network, probably.

* be.libre domains take a while to be operative.

## Caveats

* The OpenNIC ACME service cannot connect to an Yggdrasil host!
* Do not create an initial user on Debian that matches the username you want on YunoHost!
* YunoHost seems to override your DNS configuration with a list of public DNS servers (?)
* The YunoHost firewall also messes with Yggdrasil.
* The Debian package for Debian 12 is not compatible with public Yggdrasil nodes.
  The backport is good.
* At least be.libre only allows A, AAAA, NS, and TXT records.
  Mail should still work without MX records, in theory.
* Let's Encrypt does not issue OpenNIC certificates, and the only alternative seems to be an experimental CA that supports ACME.
