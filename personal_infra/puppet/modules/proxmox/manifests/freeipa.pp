class proxmox::freeipa {
  class {'proxmox':}

  file {['/etc/subuid', '/etc/subgid']:
    content => epp('proxmox/freeipa_subxid', {'freeipa' => lookup('freeipa')}),
  }

  # TODO
  service {['sssd-ssh.socket', 'sssd-pam-priv.socket', 'sssd-nss.socket', 'sssd-sudo.socket', 'sssd-pam.socket']:
    ensure => stopped,
    enable => mask,
  }
  ~>
  exec {'/usr/bin/systemctl reset-failed':
    refreshonly => true,
  }
}
