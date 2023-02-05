Update and reboot all IPA servers
https://lists.fedorahosted.org/archives/list/freeipa-users@lists.fedorahosted.org/thread/2WMK5QOAI4TYF23UKODW3M6WB65BJCHT/

firewall-cmd --permanent --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,88/udp,464/tcp,464/udp,53/
firewall-cmd --reload
ipa-client-install -p principal --domain=ipa.pdp7.net -W  --mkhomedir --ntp-pool=pool.ntp.org --force-join
ipa-replica-install --ip-address=thishostaddress -n ipa.pdp7.net -P alex --setup-ca --setup-dns --forwarder=upstreamdnsforthishost
