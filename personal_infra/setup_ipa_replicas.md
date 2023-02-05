Update and reboot all IPA servers: https://lists.fedorahosted.org/archives/list/freeipa-users@lists.fedorahosted.org/thread/2WMK5QOAI4TYF23UKODW3M6WB65BJCHT/

If the host has a firewall (e.g. physical or virtual, not LXC container):

```
firewall-cmd --permanent --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,88/udp,464/tcp,464/udp,53/
firewall-cmd --reload
```

Join the server to IPA:

```
ipa-client-install -p principal --domain=ipa.pdp7.net -W  --mkhomedir --ntp-pool=pool.ntp.org --force-join
```

Replace `--ntp-pool` with `-N` if this is a host without clock (e.g. an LXC container).
Remove `--force-join` if you have never added this host to IPA.

```
ipa-replica-install --ip-address=thishostaddress -n ipa.pdp7.net -P alex --setup-ca --setup-dns --forwarder=upstreamdnsforthishost
```

FreeIPA doesn't seem to like having different versions. When updating, when you add a new server with a new version, remove the rest of servers.
You might have issues joining new replicas otherwise.
