node 'hideo.mad.int.pdp7.net' {
  class {'workstation':}
  class {'incus':
    network_device => 'wlp3s0',
  }
  package {['zfs-dkms', 'sanoid']:}
}
