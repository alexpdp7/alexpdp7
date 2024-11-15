node 'hideo.mad.int.pdp7.net' {
  class {'workstation':}
  class {'incus':}
  class {'steam':}
  package {['zfs-dkms', 'sanoid']:}
}
