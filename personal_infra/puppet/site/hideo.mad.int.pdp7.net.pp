node 'hideo.mad.int.pdp7.net' {
  class {'workstation':}
  class {'incus':}
  class {'steam':}
  package {['zfs-dkms', 'sanoid']:}

  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1026008
  Package[$ipa_client_package]
  ->
  service {['sssd-pam-priv.socket", "sssd-sudo.socket", "sssd-nss.socket']:
    ensure => stopped,
    enable => mask,
  }
  ~>
  Exec['/usr/bin/systemctl reset-failed']
}
