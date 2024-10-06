node 'hideo.mad.int.pdp7.net' {
  class {'workstation':}
  class {'incus':}
  package {['zfs-dkms', 'sanoid']:}
}
